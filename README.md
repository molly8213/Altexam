#!/bin/bashs

# Update the system and install necessary packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql git

# Clone the PHP application from GitHub
git clone https://github.com/laravel/laravel /var/www/html/

# Create a MySQL database and user for the application
mysql -u root -p -e "CREATE DATABASE devmolly;"
mysql -u root -p -e "CREATE USER 'molly'@'localhost' IDENTIFIED BY 'vagrant';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON devmolly.* TO 'molly'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

# Configure Apache to serve the application
sudo a2enmod rewrite
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sudo systemctl restart apache2


# Secure the MySQL installation
sudo mysql_secure_installation

# Cleanup unnecessary packages and files
sudo apt autoremove -y
