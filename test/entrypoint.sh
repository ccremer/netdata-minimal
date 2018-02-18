#!/bin/sh

for file in /etc/netdata/overrides/*.ini; do
    f=$(basename ${file%.*})
    echo "Overriding /etc/netdata/${f}.conf with /etc/netdata/overrides/${f}.ini"
    crudini --inplace --merge /etc/netdata/${f}.conf < /etc/netdata/overrides/${f}.ini
done

for file in /etc/netdata/overrides/*.json; do
    f=$(basename ${file%.*})
    dest="/etc/netdata/${f}.conf"
    src="/etc/netdata/overrides/${f}.json"
    echo "Overriding ${dest} with ${src}"
    jq -s add ${dest} ${src} > ${dest}
done

echo "Starting netdata as $(id)..."
exec /usr/sbin/netdata -D
