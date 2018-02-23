#!/usr/bin/env bash

config_dir="/etc/netdata"
netdata_config="${config_dir}/netdata.conf"

# Enable netdata web
if [[ "${N_ENABLE_WEB}" == "yes" ]]; then
    crudini --inplace --set ${netdata_config} web mode static-threaded
fi
