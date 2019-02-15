#!/bin/bash
#
# Flush all current rules from iptables
iptables -F

# Set rules
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
for n in 22 80 1935 8080;
do
    iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport $n -j ACCEPT
done
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited

# Backup previous settings
iptables-save > /etc/sysconfig/iptables.prev
# These settings can be retreived with the following command:
# iptables-recover /etc/sysconfig/iptables.prev

# Save settings
/sbin/service iptables save

# Restart iptables service so the new settings can take effect
service iptables restart

# List rules
echo "New rules:"
iptables -L -v
