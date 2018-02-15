#!/bin/sh

echo "Applying default overrides"
crudini --inplace --merge /etc/netdata/netdata.conf < /etc/netdata/defaults.ini
echo "Merging custom overrides"
crudini --inplace --merge /etc/netdata/netdata.conf < /etc/netdata/overrides.ini

echo "Starting netdata as $(id)..."
exec /usr/sbin/netdata -D