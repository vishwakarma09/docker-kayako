# MySQL + Nginx Docker file.
FROM ubuntu:14.04
MAINTAINER Sandeep Kumar <kkumar.sandeep89@gmail.com>

RUN echo "mysql-server-5.6 mysql-server/root_password password redhat" | debconf-set-selections
RUN echo "mysql-server-5.6 mysql-server/root_password_again password redhat" | debconf-set-selections

ADD nginx.conf nginx.conf
ADD install.sh install.sh

RUN apt-get update && apt-get install -y mysql-server-5.6 vim nginx wget php5 php5-cli php5-fpm php5-mysql php5-mcrypt php5-gd php5-curl php5-imap && \
                cp nginx.conf /etc/nginx/sites-available/default && \
                php5enmod mcrypt && \
                php5enmod imap && \
                service php5-fpm restart && \
                service nginx restart

RUN service mysql start &&  \
        sleep 5s && \
        mysql -u root -predhat -e "GRANT ALL privileges ON *.* to 'root'@'%' identified by 'redhat'; FLUSH PRIVILEGES"

RUN update-rc.d mysql defaults && update-rc.d php5-fpm defaults && update-rc.d nginx defaults

RUN chmod +x install.sh && /bin/bash install.sh