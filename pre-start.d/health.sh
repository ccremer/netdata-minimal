#!/usr/bin/env bash

config_dir="/etc/netdata"
netdata_config="${config_dir}/netdata.conf"

# Enable netdata health
if [[ "${N_ENABLE_HEALTH}" == "yes" ]]; then
    crudini --inplace --set ${netdata_config} health enabled yes
fi
