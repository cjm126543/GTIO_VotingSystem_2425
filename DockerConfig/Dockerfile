# Usar una versión estable de Kong (ej. Kong Gateway 3.4.x Community Edition)
FROM kong:3.9.0-ubuntu

# Cambiar a usuario root para instalar utilidades necesarias
USER root

# Instalar curl (no incluido por defecto en la imagen oficial) 
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copiar el script de inicialización al contenedor
COPY kong-init.sh /usr/local/bin/kong-init.sh
RUN chmod +x /usr/local/bin/kong-init.sh

# Volver al usuario kong (no privilegiado) para ejecutar Kong
USER kong

# Sobrescribir el entrypoint para ejecutar el script de inicialización automáticamente
ENTRYPOINT ["/usr/local/bin/kong-init.sh"]
