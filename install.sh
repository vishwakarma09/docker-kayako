#enter database details here
db_user="root"
db_pass="redhat"
db_name="fusion"

#enter admin CP details here
company_name="test"
product_url="http://sandzvps.tk/"
first_name="admin"
last_name="admin"
username="admin"
password="password"
email="test@test.com"
productfiles=""
licensekey=""

#extracting product files to document root
wget -o product.tar.gz "$productfiles"
tar -xzf product.tar.gz -C /usr/share/nginx/html/
mv /usr/share/nginx/html/*/upload/* /usr/share/nginx/html/.
chown -R www-data:www-data /usr/share/nginx/html/
chmod -R 777 /usr/share/nginx/html/{__apps,__swift/files,__swift/cache,__swift/logs,__swift/geoip}
cp /usr/share/nginx/html/__swift/config/config.php.new /usr/share/nginx/html/__swift/config/config.php

#preparing config file
sed -i "s/'DB_USERNAME', 'root'/'DB_USERNAME', '$db_user'/p" /usr/share/nginx/html/__swift/config/config.php
sed -i "s/'DB_PASSWORD', ''/'DB_PASSWORD', '$db_pass'/" /usr/share/nginx/html/__swift/config/config.php
sed -i "s/'DB_NAME', 'swift'/'DB_NAME', '$db_name'/" /usr/share/nginx/html/__swift/config/config.php

#start mysql and nginx
service mysql start
service nginx start
service php5-fpm start

#creating database
mysql -u$db_user -p$db_pass -e "create database $db_name default character set utf8 collate utf8_unicode_ci"

#run setup script
#Need data in format of "Company Name" "Product URL" "First Name" "Last Name" "Username" "Password" "Email" 
php /usr/share/nginx/html/setup/console.setup.php 
