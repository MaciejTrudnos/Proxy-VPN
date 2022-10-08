FROM ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install squid -y
RUN apt-get install openvpn -y unzip

COPY squid.conf /etc/squid/squid.conf
COPY entrypoint.sh /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]