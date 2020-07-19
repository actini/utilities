FROM php:fpm-alpine

RUN docker-php-ext-install pdo_mysql

COPY ./dockerfiles/phpfpm/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY ./ /project/

RUN chmod -R 777 /project/storage