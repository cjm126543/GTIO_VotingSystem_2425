# Bienvenida
Este es el readme del repositorio **GTIOVotingSystem2425**, desarrollado por Carlos Jimeno, David Muñoz, Mayra Nogales, Iñigo Varela y Miguel Sagaseta de Ilúrdoz.
                                ![imagen](https://github.com/user-attachments/assets/bf152586-75a0-4e0c-b4e1-0c720d74ac9d)


# Estructura básica del repo
Nuestro repositorio cuenta con tres ramas diferenciadas:
- **Develop**: Rama por defecto. Sobre esta se trabaja de manera permanente y es dónde se suben los cambios realizados en un primer lugar.
- **Test**: Rama para el testeo. Sobre esta rama se prueban las pipelines y los procesos en un entorno controlado. Se ejecutan diferentes test y sirve como copia de seguridad con respecto a todo el proyecto.
- **Productive**: Rama de producción. Sobre esta rama se ofrece la versión más estable (hasta el momento) del producto. Sobre esta rama se llevan a cabo los diferentes procesos de integración y despligue continuos. 

# Estructura de la solución
Por su parte, en cada una de las ramas, se ha estructurado el proyecto de forma uniforme. Cada rama cuenta con distintas carpetas que contienen partes de la solución relevantes para la  aplicación de la rama en concreto.

Dentro de **develop**, se encuentra el código fuente de nuestra aplicación, separado por carpetas de acuerdo a la [arquitectura](https://github.com/GTIOVotingSystem2425/GTIO_VotingSystem_2425/wiki/ADRs#adr004_20250216_arquitecturaaplicaci%C3%B3n) que seguimos en nuestra solución.

La rama de **test**, tal y como se ha indicado, contiene una copia de todo el contenido, además de ser el lugar desde donde se han realizado pruebas de test unitarios, GitHub Actions, etc.

Por último, la rama **productive** contendrá lo necesario para desplegar la aplicación en los entornos de producción, levantando nuestra infraestructura en [AWS](https://github.com/GTIOVotingSystem2425/GTIO_VotingSystem_2425/wiki/ADRs#adr019_20250505_despliegue_servicios_aws_back) y llevando a cabo este proceso a través de [Terraform](https://github.com/GTIOVotingSystem2425/GTIO_VotingSystem_2425/wiki/ADRs#adr022_20250520_terraform) 

# Documentación
Toda la documentación relevante para entender las decisiones tomadas en este proyecto, así como diversas cuestiones de arquitectura o despliegue del proyecto en local, se encuentran debidamente referenciadas en nuestra [wiki](https://github.com/GTIOVotingSystem2425/GTIO_VotingSystem_2425/wiki).

La wiki cuenta con los siguientes contenidos:
                                                
 ![imagen](https://github.com/user-attachments/assets/51330c5e-9d31-47df-b996-f5fbf876004e) 


Donde se desglosan los documentos **ADR** (Architecture Decision Records), los diversos **RFI** (Requests For Information) que se han ido desarrollando a lo largo de la vida del proyecto y otras cuestiones como un diccionario de términos o algunos enlaces de interés.



# Cómo ejecutar el proyecto
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
