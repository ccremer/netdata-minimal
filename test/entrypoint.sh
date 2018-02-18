#!/bin/sh

for file in /etc/netdata/overrides/*.ini; do
    f="$(basename ${file%.*})"
    dest="/etc/netdata/${f}.conf"
    src="/etc/netdata/overrides/${f}.ini"
    echo "Overriding ${dest} with ${src}"
    crudini --inplace --merge ${dest} < ${src}
done

for file in /etc/netdata/overrides/*.json; do
    f="$(basename ${file%.*})"
    dest="/etc/netdata/${f}.conf"
    src="/etc/netdata/overrides/${f}.json"
    echo "Overriding ${dest} with ${src}"
    jq -s add ${dest} ${src} > ${dest}
done

echo "Starting netdata as $(id)..."
exec /usr/sbin/netdata -D
