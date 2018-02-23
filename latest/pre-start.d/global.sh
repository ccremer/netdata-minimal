#!/usr/bin/env bash

config_dir="/etc/netdata"
netdata_config="${config_dir}/netdata.conf"

# Set the hostname
if [[ -n ${N_HOSTNAME} ]]; then
    crudini --inplace --set ${netdata_config} global hostname "${N_HOSTNAME}"
fi

# Set memory mode
crudini --inplace --set ${netdata_config} global "memory mode" "${N_MEMORY_MODE}"
