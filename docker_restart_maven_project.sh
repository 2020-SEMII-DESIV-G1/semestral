#!/bin/bash
#===============================================================================
#
#          FILE:  docker_restart_maven_project.sh
#
#         USAGE:  ./docker_restart_maven_project.sh
#
#   DESCRIPTION: Inicializa o reinicializa un proyecto maven llamado: `project`.
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Erick Agrazal, erick@agrazal.com
#       COMPANY:  P.E.Q.A
#       VERSION:  1.0
#       CREATED:  30/NOV/2020 10:31:01 AM GMT-5
#      REVISION:  ---
#===============================================================================

#===============================================================================
# Script Variables #============================================================
#===============================================================================
MAVEN_DIRECTORY=project
MAVEN_PROJECT_NAME=example_name

#===============================================================================
# Script Logic #================================================================
#===============================================================================
# Elimina la carpeta `project` si existe.
sudo rm -rf $MAVEN_DIRECTORY

# Inicializa el proyecto de maven usando el plugin: `maven-archetype-quickstart`
$PWD/docker_run.sh mvn archetype:generate \
                    -DgroupId=com.peqa.$MAVEN_PROJECT_NAME \
                    -DartifactId=$MAVEN_PROJECT_NAME \
                    -DarchetypeArtifactId=maven-archetype-quickstart \
                    -DinteractiveMode=false

# Corrige los permisos de la carpeta `project` que fue generada dentro de maven
# con permisos de root.
sudo chown -R $USER:$(id -gn $USER) ./$MAVEN_DIRECTORY

# Agrega el compiler source para evirar un error de compilación en esta versión
# de Maven.
DOCKER_PWD=$PWD/docker_run.sh pwd
COMPILER_FIX="<properties>\n<maven.compiler.source>11</maven.compiler.source>\n<maven.compiler.target>11</maven.compiler.target>\n</properties>"
COMPILER_FIX_PROCESSED=$(echo $COMPILER_FIX | sed 's/\//\\\//g')
sed "/<\/project>/ s/.*/${COMPILER_FIX_PROCESSED}\n&/" $DOCKER_PWD/$MAVEN_PROJECT_NAME/pom.xml