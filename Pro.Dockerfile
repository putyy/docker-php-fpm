FROM php74:base

LABEL maintainer="10945014@qq.com" version="1.0" license="MIT"

ARG timezone

ENV PHPIZE_DEPS="php7-fpm"

ENV TIMEZONE=${timezone:-"Asia/Shanghai"}

COPY conf/php-fpm.conf /etc/nginx/conf.d/php-fpm.conf
COPY conf/99-overrides.ini /etc/php7/conf.d/99-overrides.ini
COPY conf/x-overrides-fpm.conf /etc/php7/php-fpm.d/x-overrides-fpm.conf

RUN set -ex \
    && apk update \
    && apk add --no-cache $PHPIZE_DEPS \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && mkdir -p /www/php \
    && echo "" > /www/php/php-cgi-74.sock \
    && echo "" > /www/php/php74-stdout.log \
    && chown -R nobody:nobody /www/php \
    && php -v \
    && php -m \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

WORKDIR /www

ENTRYPOINT ["sh","-c","/usr/sbin/php-fpm7 -D && tail -f /www/php/php74-stdout.log"]