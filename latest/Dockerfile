FROM firehol/netdata:alpine

CMD ["/entrypoint.sh"]

WORKDIR /etc/netdata

USER root:root

COPY ["entrypoint.sh", "*.ini", "*.json", "*.conf", "/etc/netdata/overrides/"]

RUN \
    apk --no-cache add \
        ca-certificates \
        py-pip \
        curl \
        bash \
        nodejs-npm \
        && \
    ln -sf /bin/bash /bin/sh && \
    # Install crudini (not available as alpine pkg)
    pip install --no-cache-dir crudini && \
    # Install merge-yaml-cli
    npm install -g merge-yaml-cli && \
    apk del py-pip nodejs-npm && \
    mv overrides/entrypoint.sh / && \
    chmod +x /entrypoint.sh /usr/bin/crudini && \
    mv overrides/stream.conf /etc/netdata/ && \
    crudini --inplace --merge netdata.conf < overrides/netdata.ini && \
    cp overrides/stream.ini overrides/netdata.ini

ENV \
    N_ENABLE_WEB="no" \
    N_ENABLE_PYTHON_D="no" \
    N_ENABLE_NODE_D="no"
