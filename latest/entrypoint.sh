#!/bin/sh

config_dir="/etc/netdata"
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

# ---------------------------------------------------------
# The actual work

execute_script "${pre_start_script}"

find ${config_dir}/overrides/ -name "*.ini"  -type f | while read file; do override_ini  "${file}"; done
find ${config_dir}/overrides/ -name "*.json" -type f | while read file; do override_json "${file}"; done

if [[ "${ENABLE_WEB:-false}" == "true" ]]; then
    crudini --inplace --set ${config_dir}/netdata.conf web mode static-threaded
fi

execute_script "${post_start_script}"

echo "Starting netdata as $(id)..."
exec /usr/sbin/netdata -D
