#!/bin/sh

config_dir="/etc/netdata"
stream_config="${config_dir}/stream.conf"
netdata_config="${config_dir}/netdata.conf"

pre_start_script="${config_dir}/overrides/pre-start.sh"
post_start_script="${config_dir}/overrides/post-start.sh"

# ---------------------------------------------------------
# Functions

execute_script() {
    script="${1}"
    if [[ -f "${script}" ]]; then
        echo "Executing ${script}"
        sh ${script}
        out=$?
        if [[ ${out} -gt 0 ]]; then
            echo "${script} exited with exit code ${out}"
            exit ${out}
        fi
    fi
}

override_ini() {
    f="$(basename ${1%.*})"
    dest="${config_dir}/${f}.conf"
    src="${config_dir}/overrides/${f}.ini"
    echo "Overriding ${dest} with ${src}"
    crudini --inplace --merge ${dest} < ${src}
}

override_json() {
    f="$(basename ${1%.*})"
    dest="${config_dir}/${f}.conf"
    src="${config_dir}/overrides/${f}.json"
    echo "Overriding ${dest} with ${src}"
    jq -s add ${dest} ${src} > ${dest}
}

overwrite_conf() {
    dest="${config_dir}/${f}.conf"
    src="$(basename ${1%.*})"
    echo "Overwriting ${dest} with ${src}"
    cp "${src}" "${dest}"
}

# ---------------------------------------------------------
# The actual work

execute_script "${pre_start_script}"

find ${config_dir}/overrides/ -name "*.conf" -type f | while read file; do overwrite_conf "${file}"; done
find ${config_dir}/overrides/ -name "*.ini"  -type f | while read file; do override_ini   "${file}"; done
find ${config_dir}/overrides/ -name "*.json" -type f | while read file; do override_json  "${file}"; done

# Enable netdata web
if [[ "${N_ENABLE_WEB}" == "yes" ]]; then
    crudini --inplace --set ${netdata_config} web mode static-threaded
fi

# Enable netdata health
if [[ "${N_ENABLE_HEALTH}" == "yes" ]]; then
    crudini --inplace --set ${netdata_config} health enabled yes
fi

# Enable netdata streaming to a master
if [[ -n ${N_STREAM_DESTINATION} && -n ${N_STREAM_API_KEY} ]]; then
    crudini --inplace --set ${stream_config} stream enabled yes
    crudini --inplace --set ${stream_config} stream destination "${N_STREAM_DESTINATION}"
    crudini --inplace --set ${stream_config} stream "api key" "${N_STREAM_API_KEY}"
fi

# Enable python plugins
if [[ ${N_ENABLE_PYTHON_D} == "yes" ]]; then
    crudini --inplace --set ${netdata_config} plugins python.d yes
fi

# Enable nodejs plugins
if [[ ${N_ENABLE_NODE_D} == "yes" ]]; then
    crudini --inplace --set ${netdata_config} plugins node.d yes
fi

# Set the hostname
if [[ -n ${N_HOSTNAME} ]]; then
    crudini --inplace --set ${netdata_config} global hostname "${N_HOSTNAME}"
fi

execute_script "${post_start_script}"

cat netdata.conf
cat stream.conf

echo "Starting netdata as $(id)..."
exec /usr/sbin/netdata -D
