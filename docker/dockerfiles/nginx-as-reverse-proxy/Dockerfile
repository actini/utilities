FROM nginx:mainline-alpine

ARG servername=localhost

ARG upstream=localhost:8000

ARG http=on

ARG httpport=80

ARG https=off

ARG httpsport=443

RUN if [ $http == 'on' ]; \
    then \
        curl -k https://raw.githubusercontent.com/actini/utilities/master/docker/dockerfiles/nginx-as-reverse-proxy/default.conf -o /etc/nginx/conf.d/default.conf \
        && sed -i -e "s/##SERVERNAME##/$servername/g" -e "s/##UPSTREAM##/$upstream/g" -e "s/##SERVERPORT##/$httpport/g" /etc/nginx/conf.d/default.conf \
    fi;

RUN if [ $https == 'on' ]; \
    then \
        curl -k https://raw.githubusercontent.com/actini/utilities/master/docker/dockerfiles/nginx-as-reverse-proxy/ssl-default.conf -o /etc/nginx/conf.d/ssl-default.conf \
        && sed -i -e "s/##SERVERNAME##/$servername/g" -e "s/##UPSTREAM##/$upstream/g" -e "s/##SERVERPORT##/$httpsport/g" /etc/nginx/conf.d/ssl-default.conf; \
    fi;
