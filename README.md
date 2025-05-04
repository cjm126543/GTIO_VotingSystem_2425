# Como ejecutar el proyecto
## Requisitos previos
- Tener instalado docker-engine para poder crear los contenedores docker
- Tener instalado WSL en sistemas windows (si el host donde se va a ejecutar tiene este sistema operativo)

## Pasos para la ejecución
1. Acceder a la carpeta DockerConfig y modificar el script ```kong-init.sh```.
-   En caso de sistema UNIX
    - Asignar a la variable $IP la dirección del interfaz de red principal usado (eth0, enp0s3 o similares, consultable con ```ifconfig```)
    - Ejecutar el script
-  En caso de sistema WINDOWSNT
    - Asignar a la variable $IP la dirección del interfaz de red principal usado (Adaptador de Ethernet Ethernet o similares, consultable con ```ipconfig```)
    - Ejecutar en la shell de WSL el script. En algunos casos puede que aparezca un error del estilo ```/bin/bash^M: bad interpreter: No such file or directory```. Se corrige facilmente ejecutando en la carpeta del script ```sed -i -e 's/\r$//' kong-init.sh```
2. Acceder a la carpeta DockerConfig y ejecutar el comando ```docker compose -d```

## Otros aspectos
En algunos casos puede que la ejecución del script ```kong_steps.sh``` termine la ejecución de los contenedores de front, back y bbdd. Este comportamiento se ha observado en sistemas UNIX, en WINDOWSNT los pasos de ejecución deberían bastar.

En cualquier caso, para corregir esta anomalía basta con ejecutar los contenedores de nuevo, ```docker container start sql1 back front```
