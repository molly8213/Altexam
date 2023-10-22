#!/bin/bash

sudo apt update
sudo apt upgrade -y

#INSTALLATION OF LAMPSTACK
sudo apt-get install apache2 -y

sudo apt-get install mysql-server -y

sudo add-apt-repository -y ppa:ondrej/php

sudo apt-get update

sudo apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y

sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini

sudo systemctl restart apache2

#CLONE LARAVELAPPLICATION
cd /var/www/html/ && git clone https://github.com/laravel/laravel.git

sudo apt install curl -y
curl -sS https://getcomposer.org/installer | php 
sudo mv composer.phar /usr/local/bin/composer
composer --version

#Configure Apache
cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerAdmin tshonuyi43@gmail.com
    ServerName 192.168.20.10
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Require all granted
    </Directory>
 
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF 
#enable the Apache rewrite module, and activate the Laravel virtual host 
sudo a2enmod rewrite
sudo a2ensite laravel.conf
#reload the Apache service to apply the changes
sudo systemctl restart apache2

#CONFIGURE MYSQL
echo "Creating MySQL user and database"
FORCA=$2
if [ -z "$2" ]; then
    FORCA="openss1 rand -base64 8"
fi

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $1;
CREATE USER '$1'@'localhost' IDENTIFIED BY '$FORCA';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES
MYSQL_SCRIPT  

echo "MySQL and Database created."
echo "Username: $1"
echo "Database: $1"
echo "Password: $FORCA"


