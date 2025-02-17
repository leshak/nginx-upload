ARG NGINX_VERSION=1.27.3

FROM nginx:$NGINX_VERSION-alpine AS build

ARG UPLOAD_MODULE_VERSION=2.3.0

RUN apk --update --no-cache add \
        gcc \
        make \
        libc-dev \
        g++ \
        openssl-dev \
        linux-headers \
        pcre-dev \
        zlib-dev \
        libtool \
        automake \
        autoconf \
        libmaxminddb-dev \
        git \
        bash


RUN cd /opt \
    && wget -O - http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | tar zxfv - \
    && mv /opt/nginx-$NGINX_VERSION /opt/nginx \
    && wget -O - https://github.com/Andarius/nginx-upload-module/archive/$UPLOAD_MODULE_VERSION.tar.gz | tar zxfv - \
    && mv /opt/nginx-upload-module-$UPLOAD_MODULE_VERSION /opt/nginx \
    && cd /opt/nginx \
    && ./configure --with-compat \
        --add-dynamic-module=/opt/nginx/nginx-upload-module-$UPLOAD_MODULE_VERSION \
        --with-stream \
    && make modules

FROM nginx:$NGINX_VERSION-alpine AS runner

COPY --from=build /opt/nginx/objs/ngx_http_upload_module.so /usr/lib/nginx/modules

RUN apk update && apk upgrade
# https://security.snyk.io/vuln/SNYK-ALPINE316-CURL-3179541
RUN apk add --no-cache curl>7.83.1-r5 \
    && chmod -R 644 /usr/lib/nginx/modules/ngx_http_upload_module.so

ENV UPLOAD_FOLDER /www_files/store
RUN mkdir -p "$UPLOAD_FOLDER" && chown nginx:nginx -R "$UPLOAD_FOLDER"
VOLUME /upload

COPY ./nginx.conf /etc/nginx/nginx.conf
