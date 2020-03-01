# What it does, if you don't want use the script you can do it like this line by line :
# GLPI_Installation-Script
Script d'installation de GLPI pour Centos7 with SSH connection, it uses rpm Remi repo.
# Configuration de GLPI sur Centos7 :
# OS : CENTOS 7 / Fedora 30 / RHEL 7
# Ajout des repos Epel et MariaDB :

$ sudo yum -y update
$ sudo yum install -y epel-release
$ cat <<EOF | sudo tee /etc/yum.repos.d/MariaDB.repo

Un fois la commande lancer ci-dessus Copier coller le texte ci-dessous av EOF inclu) !

----

[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
----
ps  If a version of Mariadb or else is install, make sur to clean it, uninstall it, before reinstall Mariadb :

$ sudo yum -y install MariaDB-server MariaDB-client


# Activation of MariaDB :

$ sudo systemctl enable --now mariadb

$ sudo systemctl start --now mariadb


# Database securization :

$ sudo mysql_secure_installation 

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB

      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] y
New password: ...
Re-enter new password: ...
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!

Création de la base de donnée GLPI en root:

$ mysql -u root -p

Enter password: ...
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 16
Server version: 10.4.6-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> select version();
+----------------+
| version()      |
+----------------+
| 10.4.6-MariaDB |
+----------------+
1 row in set (0.000 sec)


ps : copier coller le texte en gras :

Login : glpi
Pass : glpiDBSecret

MariaDB> CREATE USER 'glpi'@'%' IDENTIFIED BY 'glpiDBSecret';
MariaDB> GRANT USAGE ON *.* TO 'glpi'@'%' IDENTIFIED BY 'glpiDBSecret';
MariaDB> CREATE DATABASE IF NOT EXISTS `glpi` ;
MariaDB> GRANT ALL PRIVILEGES ON `glpi`.* TO 'glpi'@'%';
MariaDB> FLUSH PRIVILEGES;
MariaDB> exit
Bye




# Add  REMI repo for glpi rpm, with good PHP version for GLPI for Centos 7 / Fedora 30 or RHEL 7: 
ps : Don't try with Centos 8/ fedora 31 / RHEL 8,  you will thind lot of PHP versionning problems !

$ sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

$ sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm



# Install of necessary softs for GLPI (PHP, Apache, glpi etc...) :

$ sudo yum -y install yum-utils

$ sudo yum-config-manager --enable remi-php73

$ sudo yum-config-manager --enable remi

$ sudo yum-config-manager --enable remi-glpi94
$ sudo yum -y install httpd php php-opcache php-apcu glpi


# Activation of web server Apache :

$ sudo systemctl enable --now httpd


# Rules  Firewalld, open ports 80 (http) : 

If you have firewalld service, allow http port.
$ sudo firewall-cmd --zone=public --add-service=http –permanent

$ sudo firewall-cmd –reload
Vous pouvez desactiver votre SELinux avec cette commande :
$ sudo setenforce 0

Pour un peu plus de sécurité effectuez ces commandes :
Règles SELinux : 
Turn on some SELinux booleans required.
$ sudo setsebool -P httpd_can_network_connect on

$ sudo setsebool -P httpd_can_network_connect_db on

$ sudo setsebool -P httpd_can_sendmail on

C:Paco Garcia
M:gpaco@pm.me

