#!/bin/bash
set -e

# Esperar a que la base de datos PostgreSQL esté accesible
until (echo > /dev/tcp/$KONG_PG_HOST/5432) 2>/dev/null; do
  echo "Esperando a la base de datos en $KONG_PG_HOST:5432..."
  sleep 2
done

# Realizar migraciones de la base de datos de Kong (inicializar el esquema)
kong migrations bootstrap

# Arrancar Kong en background
kong start

# Esperar a que la Admin API de Kong esté disponible en localhost:8001
until curl -s http://localhost:8001/ > /dev/null; do
  echo "Esperando a que Kong inicie completamente..."
  sleep 1
done

# **Comienzan los pasos de configuración (equivalentes a kong_steps.sh)**

# Variables de configuración
SERVICE_NAME="postman_tools"
HOST="back-load-balancer-1381838054.us-east-1.elb.amazonaws.com"        # nombre de host del contenedor backend (en la red Docker)
PORT="8080"
URL="http://$HOST:$PORT"
RETRIES=10
# Generar clave de API codificada en base64 (manolocabezabolo -> bWFub2xvY2FiZXphYm9sbw==)
KEY=$(echo -n "manolocabezabolo" | base64)

# 1. Crear un Servicio en Kong apuntando al backend
echo "Creando servicio $SERVICE_NAME ..."
curl -s -X POST http://localhost:8001/services \
     --data "name=$SERVICE_NAME" \
     --data "url=$URL"

# 2. Ajustar parámetros del servicio (retries y path base)
curl -s -X PATCH http://localhost:8001/services/$SERVICE_NAME --data "retries=$RETRIES"
curl -s -X PATCH http://localhost:8001/services/$SERVICE_NAME --data "path=/api"

# 3. Crear una Ruta asociada al servicio (path /backend)
echo "Creando ruta /backend para el servicio..."
curl -s -X POST http://localhost:8001/services/$SERVICE_NAME/routes \
     --data "paths[]=/backend" \
     --data "name=back_route"

# 4. Etiquetar la ruta (ejemplo de uso de tags)
curl -s -X PATCH http://localhost:8001/services/$SERVICE_NAME/routes/back_route \
     --data "tags=standard"

# 5. Crear un Consumidor (cliente) llamado 'postman'
echo "Creando consumidor 'postman'..."
curl -s -X POST http://localhost:8001/consumers --data "username=postman"

# 6. Asignar el consumidor al grupo de ACL permitido (group1)
curl -s -X POST http://localhost:8001/consumers/postman/acls \
     -H "Content-Type: application/json" \
     --data '{"group":"group1"}'

# 7. Generar una credencial de autenticación (API key) para el consumidor
curl -s -X POST http://localhost:8001/consumers/postman/key-auth --data "key=$KEY"

# 8. Proteger la ruta del backend con autenticación de API Key (plugin key-auth)
echo "Habilitando plugin key-auth en la ruta..."
curl -s -X POST http://localhost:8001/routes/back_route/plugins \
     --data "name=key-auth" \
     --data "config.key_names=apikey"

# 9. Habilitar logging a archivo de todas las peticiones (plugin file-log global)
echo "Habilitando plugin file-log global..."
curl -s -X POST http://localhost:8001/plugins/ \
     -H "Content-Type: application/json" \
     --data '{"name":"file-log","config":{"path":"/tmp/kong_file.log"}}'

# Nota: para ver el log generado, ejecutar:
#   docker exec kong cat /tmp/kong_file.log

# 10. Configurar control de acceso (ACL plugin) en la ruta para permitir solo grupos autorizados
echo "Habilitando plugin ACL en la ruta..."
curl -s -X POST http://localhost:8001/routes/back_route/plugins \
     -H "Content-Type: application/json" \
     --data '{"name":"acl","config":{"allow":["group1","group2"],"hide_groups_header":true}}'

echo "Configuración de Kong completada exitosamente."

# Mantener el proceso en ejecución (Kong corre en background)
tail -f /dev/null
