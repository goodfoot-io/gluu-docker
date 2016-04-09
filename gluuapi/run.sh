#!/bin/bash

IP_ADDRESS=$(awk 'END{print $1}' /etc/hosts)

echo "master: $IP_ADDRESS" >> /etc/salt/minion

cat /etc/salt/minion

weave setup
service salt-master start
service salt-minion start
service gluu-agent start

SALT_MASTER_IPADDR=$IP_ADDRESS HOST=$(hostname -f) gluuapi runserver
