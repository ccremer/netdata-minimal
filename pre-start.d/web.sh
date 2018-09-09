#!/usr/bin/env bash

config_dir="/etc/netdata"
netdata_config="${config_dir}/netdata.conf"

# Enable netdata web
if [[ "${N_ENABLE_WEB}" == "yes" ]]; then
    crudini --inplace --set ${netdata_config} web mode static-threaded
fi

# Disable web access log
if [[ "${N_DISABLE_WEB_LOG}" == "yes" ]]; then
    rm -f /var/log/netdata/access.log
fi
