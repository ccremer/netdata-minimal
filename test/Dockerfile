FROM firehol/netdata:alpine

CMD ["/entrypoint.sh"]

WORKDIR /etc/netdata

RUN \
    apk --no-cache add \
        ca-certificates \
        py-pip \
        curl \
        bash \
        && \
    # Install crudini (not available as alpine pkg)
    pip install --no-cache-dir crudini && \
    ln -sf /bin/bash /bin/sh && \
    apk del py-pip

COPY ["entrypoint.sh", "*.ini", "*.json", "pre-start.sh", "*.conf", "/etc/netdata/overrides/"]

RUN \
    mv overrides/entrypoint.sh / && \
    chmod +x /entrypoint.sh /usr/bin/crudini && \
    mv overrides/stream.conf /etc/netdata/ && \
    crudini --inplace --merge netdata.conf < overrides/netdata.ini && \
    cp overrides/stream.ini overrides/netdata.ini && \
    # Permissions & stuff
    addgroup -g 101 -S netdata && \
    adduser -S -H -s /bin/sh -u 101 -h /etc/netdata -G netdata netdata && \
    chown -R netdata:netdata overrides && \
    find /etc/netdata -type f -exec chmod 0640 -- {} + && \
    find /usr/share/netdata -type f -exec chmod 0644 -- {} + && \
    find /var/cache/netdata -type f -exec chmod 0660 -- {} + && \
    find /var/lib/netdata -type f -exec chmod 0660 -- {} + && \
    chmod 0755 /var/log/netdata /usr/share/netdata /usr/libexec/netdata /etc/netdata && \
    chmod 0750 /var/lib/netdata /var/cache/netdata && \
    # /etc/netdata normally belongs to root, but for overrides we need permissions
    chown -R root:netdata /usr/share/netdata && \
    chown -R netdata:netdata /var/lib/netdata /var/cache/netdata /etc/netdata /usr/share/netdata/web && \
    chown -R netdata:root /var/log/netdata && \
    chown -R root:root /usr/libexec/netdata && \
    ls -lah overrides

USER netdata:netdata

ENV \
    N_ENABLE_WEB="no" \
    N_ENABLE_PYTHON_D="no" \
    N_ENABLE_NODE_D="no"
