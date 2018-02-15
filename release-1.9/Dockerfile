FROM debian:stable-slim

ARG \
    NETDATA_VERSION="tags/v1.9.0"

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
    ln -sf /dev/stdout /var/log/netdata/access.log && \
    ln -sf /dev/stdout /var/log/netdata/debug.log && \
    ln -sf /dev/stderr /var/log/netdata/error.log

EXPOSE 19999

CMD ["/entrypoint.sh"]

USER netdata:netdata

COPY entrypoint.sh /
COPY --chown=netdata:netdata ["overrides.ini", "defaults.ini", "/etc/netdata/"]
