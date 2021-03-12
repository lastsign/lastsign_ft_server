FROM debian:buster 

RUN apt-get -y update && apt-get -y upgrade && \
apt-get -y install wget nginx mariadb-server mariadb-client openssl \
php php-cli php-fpm php-mysql php-zip php-gd

COPY ./srcs/nginx.conf /
COPY ./srcs/start.sh /
COPY ./srcs/mysql_setup.sql /tmp
COPY ./srcs/wordpress.sql /
COPY ./srcs/switchindex.sh /
RUN chmod +x /switchindex.sh
RUN mv nginx.conf /etc/nginx/sites-available/nginx.conf

RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
RUN rm -rf /etc/nginx/sites-available/default
RUN unlink etc/nginx/sites-enabled/default

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-english.tar.gz
RUN tar -xzvf phpMyAdmin-4.9.7-english.tar.gz
RUN mv phpMyAdmin-4.9.7-english /var/www/phpMyAdmin
RUN rm -rf phpMyAdmin-4.9.7-english.tar.gz
COPY ./srcs/config.inc.php /var/www/phpMyAdmin/

RUN openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/certs/key.key \ 
-x509 -sha256 -days 356 -out /etc/ssl/certs/certificate.crt -subj \ 
'/C=RU/ST=XX/L=XX/O=XX/OU=XX/CN=poweredBySber'

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz -C /var/www/

RUN chmod -R 755 /var/www/*
RUN chown -R www-data:www-data /var/www/*

RUN service mysql start && mysql -u root mysql < /tmp/mysql_setup.sql && mysql wordpress < wordpress.sql

EXPOSE 80 443

RUN chmod -x start.sh
ENTRYPOINT ["sh", "start.sh"]
