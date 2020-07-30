# utilities


### Install Docker on Ubuntu

```bash
curl https://raw.githubusercontent.com/actini/utilities/master/docker/ubuntu-install.sh | sudo bash -x
```


### Install Kubeadm on Ubuntu

```bash
curl https://raw.githubusercontent.com/actini/utilities/master/kubernetes/ubuntu-install-kubeadm.sh | sudo bash -x
```

### Set up reverse proxy with Nginx

#### Proxy HTTP service of localhost:8000 on port 80

```bash
mkdir nginx-proxy && cd nginx-proxy

curl https://raw.githubusercontent.com/actini/utilities/master/docker/dockerfiles/nginx-as-reverse-proxy/Dockerfile -o Dockerfile

docker build . \
-t nginx-proxy:http \
--build-arg servername=www.example.com \
--build-arg upstream=localhost:8000 \
--build-arg http=on \
--build-arg httpport=80

docker run -d \
-p 80:80 \
--restart always \
nginx-proxy:http
```

#### Proxy HTTPS service of localhost:8000 on port 443

```bash
mkdir nginx-proxy && cd nginx-proxy

curl https://raw.githubusercontent.com/actini/utilities/master/docker/dockerfiles/nginx-as-reverse-proxy/Dockerfile -o Dockerfile

docker build . \
-t nginx-proxy:https \
--build-arg servername=www.example.com \
--build-arg upstream=localhost:8000 \
--build-arg https=on \
--build-arg httpsport=443 \
--build-arg http=off

docker run -d \
-p 443:443 \
-v /path/to/ssl/cert:/etc/nginx/ssl/server.crt \
-v /path/to/ssl/key:/etc/nginx/ssl/server.key \
--restart always \
nginx-proxy:https
```

#### Proxy both HTTP and HTTPS service of localhost:8000 on port 80 and 443

```bash
mkdir nginx-proxy && cd nginx-proxy

curl https://raw.githubusercontent.com/actini/utilities/master/docker/dockerfiles/nginx-as-reverse-proxy/Dockerfile -o Dockerfile

docker build . \
-t nginx-proxy:both \
--build-arg servername=www.example.com \
--build-arg upstream=localhost:8000 \
--build-arg https=on \
--build-arg httpsport=443 \
--build-arg http=on \
--build-arg httpport=80

docker run -d \
-p 80:80 \
-p 443:443 \
-v /path/to/ssl/cert:/etc/nginx/ssl/server.crt \
-v /path/to/ssl/key:/etc/nginx/ssl/server.key \
--restart always \
nginx-proxy:both
```
