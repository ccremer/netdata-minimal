FROM firehol/netdata:alpine

CMD ["/entrypoint.sh"]

WORKDIR /etc/netdata

USER root:root

RUN \
    apk --no-cache add \
        ca-certificates \
        py-pip \
        curl \
        bash \
        nodejs-npm \
        && \
    # Install crudini (not available as alpine pkg)
    pip install --no-cache-dir crudini && \
    npm install -g merge-yaml-cli && \
    ln -sf /bin/bash /bin/sh && \
    apk del py-pip nodejs-npm

COPY ["entrypoint.sh", "*.ini", "*.json", "*.yml", "*.conf", "/etc/netdata/overrides/"]

RUN \
    mv overrides/entrypoint.sh / && \
    chmod +x /entrypoint.sh /usr/bin/crudini && \
    mkdir -p /etc/netdata/post-start.d /etc/netdata/pre-start.d && \
    mv overrides/stream.conf /etc/netdata/ && \
    crudini --inplace --merge netdata.conf < overrides/netdata.ini && \
    cp overrides/stream.ini overrides/netdata.ini && \
    ls -lah overrides

COPY ["pre-start.d/*.sh", "/etc/netdata/pre-start.d/"]
COPY ["post-start.d/*.sh", "/etc/netdata/post-start.d/"]

ENV \
    N_ENABLE_WEB="no" \
    N_ENABLE_PYTHON_D="no" \
    N_ENABLE_NODE_D="no"
