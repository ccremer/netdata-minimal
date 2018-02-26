#!/bin/sh

# ---------------------------------------------------------
# Variables

config_dir="/etc/netdata"
stream_config="${config_dir}/stream.conf"
netdata_config="${config_dir}/netdata.conf"

# ---------------------------------------------------------
# Functions

execute_script() {
    script="${1}"
    if [[ -f "${script}" ]]; then
        log "Executing ${script}"
        bash ${script}
        out=$?
        if [[ ${out} -gt 0 ]]; then
            log "${script} exited with exit code ${out}"
            exit ${out}
        fi
    fi
}

override_ini() {
    f="$(basename ${1%.*})"
    dest="${config_dir}/${f}.conf"
    src="${config_dir}/overrides/${f}.ini"
    log "Overriding ${dest} with ${src}"
    crudini --inplace --merge ${dest} < ${src}
}

override_json() {
    f="$(basename ${1%.*})"
    dest="${config_dir}/${f}.conf"
    src="${config_dir}/overrides/${f}.json"
    log "Overriding ${dest} with ${src}"
    jq -s add ${dest} ${src} > ${dest}
}

overwrite_conf() {
    f="$(basename ${1%.*})"
    dest="${config_dir}/${f}.conf"
    src="${config_dir}/overrides/${f}.conf"
    log "Overwriting ${dest} with ${src}"
    cp "${src}" "${dest}"
}

override_yaml() {
    f="$(basename ${1%.*})"
    dest="${config_dir}/${f}.conf"
    src="${config_dir}/overrides/${f}.yml"
    orig="${dest}.orig"
    mv "${dest}" "${orig}"
    merge-yaml -i "${orig}" ${src} -o ${dest}
    echo "# This file has been written with merge-yaml, which removes helpful comments." >> ${dest}
    echo "# The original unmodified content is in ${orig}" >> ${dest}
}

log() {
    echo "[netdata] ${1}"
}

# ---------------------------------------------------------
# The actual work

find ${config_dir}/pre-start.d/ -name "*.sh"  -type f | while read file; do execute_script "${file}"; done
find ${config_dir}/overrides/ -name "*.conf"  -type f | while read file; do overwrite_conf "${file}"; done
find ${config_dir}/overrides/ -name "*.ini"   -type f | while read file; do override_ini   "${file}"; done
find ${config_dir}/overrides/ -name "*.json"  -type f | while read file; do override_json  "${file}"; done
find ${config_dir}/overrides/ -name "*.yml"   -type f | while read file; do override_yaml  "${file}"; done
find ${config_dir}/post-start.d/ -name "*.sh" -type f | while read file; do execute_script "${file}"; done

log "Preparation finished. Starting netdata..."
exec /usr/sbin/netdata -D
