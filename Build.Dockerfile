FROM php74:base

LABEL maintainer="10945014@qq.com" version="1.0" license="MIT"

ARG timezone

ENV TIMEZONE=${timezone:-"Asia/Shanghai"}

RUN set -ex \
    && pwd \
    && apk update \
    && apk add --no-cache git \
    && git --version \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

WORKDIR /www

ENTRYPOINT ["composer"]

