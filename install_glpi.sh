#!/bin/sh

################################################################################
# File: install_glpi.sh
# Objet: 
# Usage: install_glpi.sh
# Exemple: 
# Options: 
#  
# Retourne:
#   0: OK
#   1: 
# Auteur:
# Created: Thu 27 Jun 2019 06:05:14 PM CEST
# Updated: Tue 02 Jul 2019 08:59:38 AM CEST
################################################################################

SERVER=$1
CONN=root@${SERVER}

PASSWORD=P@ssw0rd

if [ "{SERVER}" = "" ]
  then
    echo "Usage : $0 serveur" >&2
    exit 2
fi

# Installation EPEL Repo
ssh ${CONN} yum install -y epel-release

# Installation MariaDB Repo
scp MariaDB.repo ${CONN}:/etc/yum.repos.d

# Installation MariaDB
ssh ${CONN} yum -y install MariaDB-server MariaDB-client

# Démarrage MariaDB
ssh ${CONN} systemctl enable --now mariadb

# Sécurisation MariaDB
cat - | ssh -t ${CONN} mysql_secure_installation <<EOF

y
${PASSWORD}
${PASSWORD}
y
y
y
y
EOF

# Installation REMI Repos
ssh ${CONN} yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
ssh ${CONN} yum-config-manager --enable remi-php73
ssh ${CONN} yum-config-manager --enable remi
ssh ${CONN} yum-config-manager --enable remi-glpi93

# Installation GLPI
ssh ${CONN} yum -y install httpd php php-opcache php-apcu glpi

# Redémmarage du serveur HTTPD
systemctl restart httpd
