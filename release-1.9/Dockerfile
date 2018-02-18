FROM debian:stable-slim

ARG \
    NETDATA_VERSION="tags/v1.9.0"

EXPOSE 19999
VOLUME ["/etc/netdata/overrides"]
CMD ["/entrypoint.sh"]

COPY ["entrypoint.sh", "*.ini", "*.conf", "/etc/netdata/overrides/"]

RUN \
    export DEBIAN_FRONTEND='noninteractive' && \
    # Install dependencies
    apt-get update && \
    apt-get upgrade -qqy && \
    apt-get install --no-install-recommends -qqy \
        zlib1g-dev \
        uuid-dev \
        gcc \
        make \
        git \
        autoconf \
        autoconf-archive \
        autogen \
        automake \
        pkg-config \
        ca-certificates \
        crudini \
        && \
    # Install netdata
    git clone https://github.com/firehol/netdata.git /usr/src/netdata && \
    cd /usr/src/netdata && \
    git checkout $NETDATA_VERSION && \
    ./netdata-installer.sh --dont-start-it --dont-wait && \
    cd / && \
    # Cleanup
    apt-get purge -y git gcc automake autogen make autoconf* && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/src/netdata && \
    # Symlink logs to stdout/err
    ln -sf /dev/stdout /var/log/netdata/debug.log && \
    ln -sf /dev/stderr /var/log/netdata/error.log && \
    # Permissions & stuff
    mv /etc/netdata/overrides/entrypoint.sh / && \
    chown -R netdata:netdata /etc/netdata && \
    mv /etc/netdata/overrides/*.conf /etc/netdata/ && \
    chmod +x /entrypoint.sh
