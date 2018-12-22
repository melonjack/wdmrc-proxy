FROM    slothds/alpine-svd:3.8

LABEL   maintainer="SlothDS" \
        maintainer.mail="sloth@devils.su" \
        maintainer.git="https://github.com/slothds"

ENV     WDMRC_VERS="1.10.2.1" \
        WDMRC_REPO="https://github.com/yar229/WebDavMailRuCloud/releases/download" \
        WDMRC_HOME="/opt/runner"

COPY    rootfs /

RUN     apk update && apk upgrade --no-cache && \
        apk add --no-cache --virtual .install-dep ca-certificates curl unzip && \
        apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
        curl -kfsSL -o /tmp/wdmrc-core.zip \
            ${WDMRC_REPO}/${WDMRC_VERS}/WebDAVCloudMailRu-${WDMRC_VERS}-dotNet45.zip && \
        mkdir -p ${WDMRC_HOME} && \
        unzip /tmp/wdmrc-core.zip -d ${WDMRC_HOME} && \
        chown -R runner:runner ${WDMRC_HOME} && \
        cat /etc/ssl/certs/* > /tmp/ca-root.crt && \
        cert-sync /tmp/ca-root.crt && \
        apk del .install-dep && \
        rm -rf /tmp/* /var/cache/apk/* /var/tmp/*

EXPOSE  8010
