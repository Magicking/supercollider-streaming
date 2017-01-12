#!/bin/sh
ip link set dev lo multicast on
ip route add 239.0.0.1/32 dev lo

AUTHORIZED_KEYS_FILE=/home/sc/.ssh/authorized_keys2
cat /authorized_keys > "$AUTHORIZED_KEYS_FILE"

/usr/bin/supervisord -c /etc/supervisor.d/supervisord.ini
