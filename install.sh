#enter database details here
db_user="root"
db_pass="redhat"
db_name="fusion"

#extracting product files to document root
tar -xzf product.tar.gz -C /usr/share/nginx/html/
mv /usr/share/nginx/html/f*/upload/* /usr/share/nginx/html/.
chown -R www-data:www-data /usr/share/nginx/html/
chmod -R 777 /usr/share/nginx/html/{__apps,__swift/files,__swift/cache,__swift/logs,__swift/geoip}
cp /usr/share/nginx/html/__swift/config/config.php.new /usr/share/nginx/html/__swift/config/config.php

#preparing config file
sed -i "s/'DB_USERNAME', 'root'/'DB_USERNAME', '$db_user'/p" /usr/share/nginx/html/__swift/config/config.php
sed -i "s/'DB_PASSWORD', ''/'DB_PASSWORD', '$db_pass'/" /usr/share/nginx/html/__swift/config/config.php
sed -i "s/'DB_NAME', 'swift'/'DB_NAME', '$db_name'/" /usr/share/nginx/html/__swift/config/config.php

#creating database
mysql -u$db_user -p$db_pass -e "create database $db_name default character set utf8 collate utf8_unicode_ci"
