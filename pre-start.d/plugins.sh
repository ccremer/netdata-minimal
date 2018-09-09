#!/usr/bin/env bash

config_dir="/etc/netdata"
netdata_config="${config_dir}/netdata.conf"

# Enable python plugins
if [[ ${N_ENABLE_PYTHON_D} == "yes" ]]; then
    crudini --inplace --set ${netdata_config} plugins python.d yes
fi

# Enable nodejs plugins
if [[ ${N_ENABLE_NODE_D} == "yes" ]]; then
    crudini --inplace --set ${netdata_config} plugins node.d yes
fi
