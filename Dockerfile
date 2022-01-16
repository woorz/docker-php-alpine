FROM alpine:3.15.0
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
# Install packages
RUN apk --no-cache update && apk --no-cache add curl php7 php7-fpm \
    php7-mysqli php7-json php7-openssl php7-curl php7-zlib php7-xml \
	php7-phar php7-intl php7-dom php7-xmlreader php7-ctype \
	php7-mbstring php7-gd nginx supervisor

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN mkdir -p /var/www/html
RUN chown -R nobody.nobody /var/www/html
COPY index.html /var/www/html

# Switch to use a non-root user from here on
USER nobody

WORKDIR /var/www/html

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
