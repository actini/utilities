FROM nginx:mainline-alpine

ARG SERVERNAME

ARG SERVERROOT

COPY default.conf /etc/nginx/conf.d/default.conf

RUN sed -i -e "s/##SERVERNAME##/$SERVERNAME/g" -e "s/##SERVERROOT##/`echo $SERVERROOT | sed 's/\//\\\\\//g'`/g" /etc/nginx/conf.d/default.conf