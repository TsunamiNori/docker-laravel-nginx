FROM alpine:3.12
LABEL Maintainer="Tsunami Nori <tsunaminori@gmail.com>" \
      Description="Lightweight container with Nginx 1.18 & PHP-FPM 7.3 based on Alpine Linux."
ENV TZ=Asia/Ho_Chi_Minh

COPY entry.sh /entry.sh
# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install packages and remove default server definition
RUN  set -x  \
  && addgroup -g 1001 -S www-data \
  && adduser -u 1001 -D -S -h /var/cache/nginx -s /sbin/nologin -G www-data www-data \
  && apk add --no-cache --update --virtual .build-deps \
      php7 \
      php7-dev \
      php7-bcmath \
      php7-dom \
      php7-common \
      php7-ctype \
      php7-cli \
      php7-curl \
      php7-fileinfo \
      php7-fpm \
      php7-gettext \
      php7-gd \
      php7-iconv \
      php7-json \
      php7-mbstring \
      php7-mcrypt \
      php7-mysqli \
      php7-mysqlnd \
      php7-opcache \
      php7-odbc \
      php7-pdo \
      php7-pdo_mysql \
      php7-pdo_pgsql \
      php7-pdo_sqlite \
      php7-phar \
      php7-posix \
      php7-redis \
      php7-session \
      php7-simplexml \
      php7-soap \
      php7-tokenizer \
      php7-xml \
      php7-xmlreader \
      php7-xmlwriter \
      php7-simplexml \
      php7-zip \
      php7-zlib \
	  nginx supervisor curl && \
    rm /etc/nginx/conf.d/default.conf  && \
   rm -rf /tmp/* && \
   rm -rf /var/cache/apk/*

COPY --from=composer /usr/bin/composer /usr/bin/composer

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/mime.types /etc/nginx/mime.types

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini

RUN mkdir -p ~/.composer && echo "{}" > ~/.composer/composer.json \ 
	&& mkdir -p /var/www/html \
	&& mkdir -p /run/php && chmod 777 /run/php \
    && rm -rf /root/.composer/cache \
	&& chmod +x /entry.sh \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/*

# Add application
WORKDIR /var/www/html

# Expose the port nginx is reachable on
EXPOSE 80


ENTRYPOINT ["/entry.sh"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=3s CMD curl --silent --fail http://127.0.0.1/ping
