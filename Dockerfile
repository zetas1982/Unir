FROM ubuntu:18.04

MAINTAINER Antonio Jimenez <oscense32@gmail.com>

LABEL description="Apache / PHP UNIR"

ARG DEBIAN_FRONTEND=newt

RUN apt-get -y update && apt-get install -y \
apache2 \
php7.2 \
libapache2-mod-php7.2 \
php7.2-bcmath \
php7.2-gd \
php7.2-json \
php7.2-sqlite \
php7.2-mysql \
php7.2-curl \
php7.2-xml \
php7.2-mbstring \
mcrypt \
nano

RUN apt-get install locales
RUN locale-gen fr_FR.UTF-8
RUN locale-gen en_US.UTF-8
RUN locale-gen de_DE.UTF-8

# configuramos PHP
# mostramos errores PHP
RUN sed -i -e 's/^error_reporting\s*=.*/error_reporting = E_ALL/' /etc/php/7.2/apache2/php.ini
RUN sed -i -e 's/^display_errors\s*=.*/display_errors = On/' /etc/php/7.2/apache2/php.ini
RUN sed -i -e 's/^zlib.output_compression\s*=.*/zlib.output_compression = Off/' /etc/php/7.2/apache2/php.ini

# permitimos usar  "nano" con shell on "docker exec -it [CONTAINER ID] bash"
ENV TERM xterm

# determinamos el domain name"
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
# autorizamos .htaccess files
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN chgrp -R www-data /var/www
RUN find /var/www -type d -exec chmod 775 {} +
RUN find /var/www -type f -exec chmod 664 {} +

EXPOSE 80

# arrancamos Apache2 en la imagen
CMD ["/usr/sbin/apache2ctl","-DFOREGROUND"]
