#!/bin/bash

create_openvpn_dev_net() {
	mkdir -p /dev/net
	mknod /dev/net/tun c 10 200
	chmod 600 /dev/net/tun
}

restart_services() {
  /etc/init.d/squid restart 
  /etc/init.d/openvpn restart 
}

connect() {
	cd /etc/openvpn/configurations
	openvpn ${openvpn_file_name}
}

create_openvpn_dev_net
restart_services
connect