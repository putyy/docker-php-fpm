### 基础镜像构建
##### base版本构建方式
```shell
docker build --build-arg ALPINE_VERSION=3.12 -t php74:base -f Base.Dockerfile .
docker push php74:base
```

##### fpm-pro
```shell
docker build -t php74:fpm-pro -f Pro.Dockerfile .
docker push php74:fpm-pro
```

##### fpm-pro-nginx
```shell
docker build -t php74:fpm-pro-nginx -f ProNginx.Dockerfile .
docker push php74:fpm-pro-nginx
```

##### build镜像构建
```shell
docker build -t php74:build-dev -f Build.Dockerfile .

# 创建容器 设置git相关
# docker run -it --entrypoint /bin/sh php74:build-dev
# git conf --global credential.helper store
# git clone http://xx.xxx.cn ./xxx
# 输入用户名密码...
# rm -rf xxx

# 宿主机
docker commit -a "10945014@qq.com" -m "项目打包镜像" 5x14xxxxfxd php74:build
docker push php74:build
```


### 项目打包流程
##### 项目dockerfile, 假设项目为Laravel
```shell
FROM php74:fpm-pro-nginx

LABEL maintainer="10945014@qq.com" version="1.0" license="MIT"

ENV PROJECT="/www/web-project"

COPY --chown=nobody:nobody . ${PROJECT}

RUN set -ex \
    && cd ${PROJECT} \
    && cat .env.example > .env \
    && php artisan config:cache \
    && php artisan route:cache \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
```

##### 先构建项目所需依赖
```shell
# 挂载一下composer缓存目录 这样构建就会快一些
docker run --rm -it --entrypoint composer \
-v /www/lm-docker/www/composer-cache:/root/.composer/cache \
-v /www/api:/www \
php74:build install -o --no-dev
```

##### 项目打包成镜像
```shell
docker build -t api:test -f Dockerfile .
docker push api:test
```

### 参考
```shell
https://github.com/hyperf/hyperf-docker
https://github.com/codecasts/php-alpine
```