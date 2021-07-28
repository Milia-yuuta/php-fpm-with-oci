FROM debian:buster AS OIC

# Oracle Instant Client
ARG INSTANT_CLIENT_VERSION="21.1.0.0.0"
ARG INSTANT_CLIENT_VERSION_WITOUT_DOT="211000"
ARG DOWNLOAD_LINK_BASE="https://download.oracle.com/otn_software/linux/instantclient"

WORKDIR /opt/oracle

RUN apt-get update \
    && apt-get install -y zip unzip curl \
    && curl -sSL $DOWNLOAD_LINK_BASE/$INSTANT_CLIENT_VERSION_WITOUT_DOT/instantclient-basic-linux.x64-$INSTANT_CLIENT_VERSION.zip > \
        instantclient-basic-linux.x64-$INSTANT_CLIENT_VERSION.zip \
    && curl -sSL $DOWNLOAD_LINK_BASE/$INSTANT_CLIENT_VERSION_WITOUT_DOT/instantclient-sdk-linux.x64-$INSTANT_CLIENT_VERSION.zip > \
        instantclient-sdk-linux.x64-$INSTANT_CLIENT_VERSION.zip \
    && unzip '*.zip'


FROM php:8.0-fpm

# define Oracle Instant Client install path
ENV ORACLE_BASE=/opt/oracle
ENV ORACLE_INSTANT_CLIENT_DIR=$ORACLE_BASE/instantclient
ENV LD_LIBRARY_PATH="$ORACLE_INSTANT_CLIENT_DIR:$LD_LIBRARY_PATH"

ARG INSTANT_CLIENT_UNZIPED_NAME="instantclient_21_1"

WORKDIR /var/www/html
COPY --from=OIC /opt/oracle/$INSTANT_CLIENT_UNZIPED_NAME $ORACLE_INSTANT_CLIENT_DIR

ENV PHP_DTRACE=yes

RUN apt-get update \
    && apt-get install -y \
        autoconf \
        build-essential \
        libzip-dev \
        libicu-dev \
        libaio-dev \
    && apt-get install -y \
        icu-devtools \
        systemtap-sdt-dev \
    && docker-php-ext-configure oci8 --with-oci8=instantclient,$ORACLE_INSTANT_CLIENT_DIR && docker-php-ext-install oci8 \
    && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,$ORACLE_INSTANT_CLIENT_DIR && docker-php-ext-install pdo_oci