FROM php74:fpm-pro

LABEL maintainer="10945014@qq.com" version="1.0" license="MIT"

RUN set -ex \
    && apk update \
    && apk add --no-cache nginx \
    && mkdir -p /run/nginx /www/nginx \
    && chown -R nobody:nobody /www/nginx \
    && sed -i 's/user nginx/user nobody/g' /etc/nginx/nginx.conf \
    && php -v \
    && php -m \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

WORKDIR /www

EXPOSE 8000

ENTRYPOINT ["sh","-c","/usr/sbin/php-fpm7 -D && nginx && tail -f /www/php/php74-stdout.log"]