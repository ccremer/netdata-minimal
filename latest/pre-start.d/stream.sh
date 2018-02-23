#!/usr/bin/env bash

config_dir="/etc/netdata"
stream_config="${config_dir}/stream.conf"

# Enable netdata streaming to a master
if [[ -n ${N_STREAM_DESTINATION} && -n ${N_STREAM_API_KEY} ]]; then
    crudini --inplace --set ${stream_config} stream enabled yes
    crudini --inplace --set ${stream_config} stream destination "${N_STREAM_DESTINATION}"
    crudini --inplace --set ${stream_config} stream "api key" "${N_STREAM_API_KEY}"
fi

# Enable netdata streaming master
if [[ -n ${N_STREAM_API_KEY} && -n ${N_STREAM_MASTER_MEMORY} ]]; then
    crudini --inplace --set ${stream_config} "${N_STREAM_API_KEY}" "enabled" yes
    crudini --inplace --set ${stream_config} "${N_STREAM_API_KEY}" "default history" 3600
    crudini --inplace --set ${stream_config} "${N_STREAM_API_KEY}" "default memory" "${N_STREAM_MASTER_MEMORY}"
    crudini --inplace --set ${stream_config} "${N_STREAM_API_KEY}" "health enabled by default" auto
fi
