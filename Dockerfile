FROM alpine

ARG VER=3.1.3
ARG URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$VER/shadowsocks-libev-$VER.tar.gz

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 443
ENV PD=
ENV METHOD      aes-256-cfb
ENV TIMEOUT     300

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
                                autoconf \
                                build-base \
                                curl \
                                libev-dev \
                                linux-headers \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                tar \
                                c-ares-dev && \
    cd /tmp && \
    curl -sSL $URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \

    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/*

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

CMD ss-server -s $SERVER_ADDR -p $SERVER_PORT -k ${PD:-$(hostname)} -m $METHOD -t $TIMEOUT -u
