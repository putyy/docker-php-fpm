ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION

LABEL maintainer="10945014@qq.com" version="1.0" license="MIT"

ARG ALPINE_VERSION

ADD https://alpine-apk-repository.knowyourself.cc/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
COPY composer/composer.phar /usr/local/bin/composer

RUN set -ex \
    && chmod u+x /usr/local/bin/composer \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && echo "https://alpine-apk-repository.knowyourself.cc/v$ALPINE_VERSION/php-7.4" >> /etc/apk/repositories \
    && echo "@php https://alpine-apk-repository.knowyourself.cc/v$ALPINE_VERSION/php-7.4" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
    ca-certificates \
    curl \
    wget \
    tar \
    xz \
    libressl \
    tzdata \
    pcre \
    php7 \
    php7-bcmath \
    php7-curl \
    php7-ctype \
    php7-dom \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-mysqlnd \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-phar \
    php7-posix \
    php7-redis \
    php7-sockets \
    php7-sodium \
    php7-sysvshm \
    php7-sysvmsg \
    php7-sysvsem \
    php7-zip \
    php7-zlib \
    php7-xml \
    php7-xmlreader \
    php7-pcntl \
    php7-opcache \
    && ln -sf /usr/bin/php7 /usr/bin/php \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 \
    && php -v \
    && php -m \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
