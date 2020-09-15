FROM alpine as builder

RUN apk add --no-cache curl unzip patch g++ pcre-dev zlib-dev make

WORKDIR /build

RUN curl -L http://nginx.org/download/nginx-1.18.0.tar.gz -o nginx-1.18.0.tar.gz \
        && curl -L https://github.com/chobits/ngx_http_proxy_connect_module/archive/master.zip -o ngx_http_proxy_connect_module.zip \
        && curl -L https://raw.githubusercontent.com/chobits/ngx_http_proxy_connect_module/master/patch/proxy_connect_rewrite_1018.patch -o proxy_connect_rewrite_1018.patch \
        && mkdir nginx && tar -zxf nginx-1.18.0.tar.gz -C nginx \
        && mkdir proxy_connect && unzip ngx_http_proxy_connect_module.zip -d proxy_connect

RUN cd nginx/nginx-1.18.0 \
        && patch -p1 < /build/proxy_connect_rewrite_1018.patch \
        && ./configure --add-dynamic-module=/build/proxy_connect/ngx_http_proxy_connect_module-master \
        && make \
        && make install \
        && curl -L https://raw.githubusercontent.com/actini/utilities/master/docker/dockerfiles/nginx-as-connect-proxy/nginx.conf -o /usr/local/nginx/conf/nginx.conf

FROM alpine

RUN apk add --no-cache pcre-dev

WORKDIR /usr/local/nginx

COPY --from=builder /usr/local/nginx .

EXPOSE 80

CMD ["/usr/local/nginx/sbin/nginx", "-c", "/usr/local/nginx/conf/nginx.conf"]
