#!/bin/sh
## sleep 1000000
/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg &
{tor_instances}