#!/bin/bash

### Function to load rules and start fresh ###
function load_rules {
	iptables -t nat -F; iptables -F
	iptables -P FORWARD DROP; iptables -P INPUT DROP; iptables -P OUTPUT DROP
	iptables -A FORWARD -p TCP -s 10.1.1.10 -d 10.2.2.10 --sport 80 -j ACCEPT
	iptables -A FORWARD -p TCP -s 10.2.2.10 -d 10.1.1.10 --dport 80 -j ACCEPT
	echo 1 > /proc/sys/net/ipv4/ip_forward
	for f in /proc/sys/net/ipv4/conf/*/rp_filter; do echo 1 > $f; done
}
case "$1" in
	stop)
		echo "Flushing iptables rules..."
		iptables -t nat -F; iptables -F; iptables -P FORWARD ACCEPT
		iptables -P INPUT ACCEPT; iptables -P OUTPUT ACCEPT
	;;
	start)
		load_rules  #call the function
	;;
	restart)
		echo "Reloading firewall rules..."
		iptables -F
		load_rules  #call the function
	;;
	*)
		echo "Usage: $N (start|stop|restart)" >&2
		exit 1
	;;
csac
iptables --list -n