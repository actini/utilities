FROM nginx:mainline-alpine

ARG SERVERNAME

COPY default.conf /etc/nginx/conf.d/default.conf

RUN sed -i -e "s/##SERVERNAME##/$SERVERNAME/g" /etc/nginx/conf.d/default.conf
