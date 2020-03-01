# GLPI_Installation-Script
Script d'installation de GLPI pour Centos7 with SSH connection, it uses rpm Remi repo.
# OS : CENTOS 7 / Fedora 30
# GLPI : 9.4
# For info Remi Repo :
https://blog.remirepo.net/post/2018/12/21/GLPI-version-9.4-en
$ yum-config-manager --enable remi-glpi94
$ yum-config-manager --enable remi
$ yum install glpi
$ dnf module enable glpi:9.4
$ dnf install glpi

# Available Repo :

    glpi-9.4.5-1
    glpi-appliances-2.5.1-1
    glpi-archires-2.7.0-1
    glpi-behaviors-2.2.2-1
    glpi-datainjection-2.7.1-1
    glpi-fusioninventory-9.4+2.4-1
    glpi-ocsinventoryng-1.6.0-1
    glpi-pdf-1.6.0-1
    glpi-reports-1.13.1-1
    glpi-webservices-2.0.0-1

