#!/bin/sh
host="$(hostname -i || echo '127.0.0.1')"
if ping="$(redis-cli -h "$host" ping 2>&1)" && [ "$ping" = 'PONG' ]; then
	exit 0
fi
exit 1
