FROM firehol/netdata:armv7hf

RUN ["cross-build-start"]

CMD ["/netdata.sh"]

WORKDIR /etc/netdata

COPY ["netdata.sh", "*.ini", "*.conf", "/etc/netdata/overrides/"]

RUN \
    apt-get update && \
    apt-get upgrade && \
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    apt-get install -qqy --no-install-recommends \
        ca-certificates \
        python-pip \
        nodejs \
        # for fping:
        libcap2-bin \
        && \
    curl -sL -o /var/cache/apt/archives/fping_armhf.deb http://ftp.uk.debian.org/debian/pool/main/f/fping/fping_4.0-6_armhf.deb && \
    dpkg -i /var/cache/apt/archives/fping_armhf.deb && \
    # Cleanup
    apt-get clean && \
    # Install crudini
    pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir crudini && \
    # Install merge-yaml-cli
    npm config set unsafe-perm true && \
    npm install -g merge-yaml-cli && \
    # Prepare scripts
    mv overrides/netdata.sh / && \
    chmod +x /netdata.sh /usr/local/bin/crudini && \
    mkdir -p /etc/netdata/post-start.d /etc/netdata/pre-start.d && \
    # Apply config
    mv overrides/stream.conf /etc/netdata/ && \
    crudini --inplace --merge netdata.conf < overrides/netdata.ini && \
    cp overrides/stream.ini overrides/netdata.ini

COPY ["pre-start.d/*.sh", "/etc/netdata/pre-start.d/"]

ENV \
    N_ENABLE_WEB="no" \
    N_ENABLE_PYTHON_D="no" \
    N_ENABLE_NODE_D="no" \
    N_MEMORY_MODE="save"\
    N_STREAM_MASTER_HEALTH="auto"

RUN ["cross-build-end"]