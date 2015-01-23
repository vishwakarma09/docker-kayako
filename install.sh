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
productfiles="http://ghostnode.tk/fusion.tar.gz"
licensekey="http://ghostnode.tk/key.php.txt"
geoipfiles="http://ghostnode.tk/geoip.tar.gz"

#extracting product files to document root
wget -O product.tar.gz "$productfiles"
wget -O key.php "$licensekey"
wget -O geoip.tar.gz "$geoipfiles"
tar -xzf product.tar.gz -C /usr/share/nginx/html/
mv /usr/share/nginx/html/*stable*/upload/* /usr/share/nginx/html/
tar -xzf geoip.tar.gz
mv geoiplite*/* /usr/share/nginx/html/__swift/geoip/
chown -R www-data:www-data /usr/share/nginx/html/
chmod -R 777 /usr/share/nginx/html/{__apps,__swift/files,__swift/cache,__swift/logs,__swift/geoip}
cp /usr/share/nginx/html/__swift/config/config.php.new /usr/share/nginx/html/__swift/config/config.php

#preparing config file
sed -i "s/'DB_USERNAME', 'root'/'DB_USERNAME', '$db_user'/" /usr/share/nginx/html/__swift/config/config.php
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
cd /usr/share/nginx/html/setup/
php console.setup.php $company_name test $first_name $last_name $username $password $email 
rm -rf /usr/share/nginx/html/setup/
cp /key.php /usr/share/nginx/html/key.php

mysql -u $db_user $db_name -p$db_pass -e "update swsettings set data=\'$product_url\' where vkey='general_producturl';"
#rebuildurl="staff/index.php?/Core/Default/RebuildCache"
#wget "$product_url$rebuildurl"

#give zero exit code
exit 0
