# Proxy-VPN

[![Docker](https://img.shields.io/badge/dockerhub-maciejtrudnos/proxy--vpn-blue?logo=docker&logoColor=white)](https://hub.docker.com/r/maciejtrudnos/proxy-vpn)

[Docker](https://www.docker.com/) image for [Squid proxy server](http://www.squid-cache.org/) and [OpenVPN](https://openvpn.net).

Proxy Squid separate end users from the websites they browse using OpenVPN secure connection

## Getting started
Pull docker image from dockerhub
```sh
$ docker pull maciejtrudnos/proxy-vpn
```
or build image
```sh
$ docker build -t maciejtrudnos/proxy-vpn .
```
Create single container by docker-compose
```sh
$ docker-compose -f single-proxy-vpn.yml up -d
```
Create multiple containers by docker-compose
```sh
$ docker-compose -f multiple-proxy-vpn.yml up -d
```

## Usage

Here are some example snippets to help you get started creating a container

#### docker-compose for single container 

```console
ubuntu:
  image: maciejtrudnos/proxy-vpn
  container_name: proxy-vpn-container
  volumes:
    - /path/to/ovpn-files:/etc/openvpn/configurations
  ports:
    - 3128:3128
  tty: true
  cap_add:
    - NET_ADMIN
  environment:
    openvpn_file_name:ovpn-file-use-to-connect.ovpn
  dns:
    - 8.8.8.8
    - 8.8.4.4
```

#### docker-compose for multiple container 

```console
services:
  au:
    image: maciejtrudnos/proxy-vpn
    container_name: au-container
    volumes:
      - /path/to/ovpn-files:/etc/openvpn/configurations
    ports:
      - 3128:3128
    tty: true
    cap_add:
      - NET_ADMIN
    environment:
      openvpn_file_name:ovpn-file-use-to-connect.ovpn
    dns:
      - 8.8.8.8
      - 8.8.4.4
  be:
    image: maciejtrudnos/proxy-vpn
    container_name: be-container
    volumes:
      - /path/to/ovpn-files:/etc/openvpn/configurations
    ports:
      - 3129:3128
    tty: true
    cap_add:
      - NET_ADMIN
    environment:
      openvpn_file_name:ovpn-file-use-to-connect.ovpn
    dns:
      - 8.8.8.8
      - 8.8.4.4
```

#### Test connection using curl
```sh
$ curl --proxy "127.0.0.1:3128" "http://httpbin.org/ip"
```

## Advanced Configuration

Fix IP conflict when connection refused form another machine

#### Find which IP address are being used by your local network
```sh
$ route -n

Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.20.96.1     0.0.0.0         UG    100    0        0 eth0
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
172.20.96.0     0.0.0.0         255.255.240.0   U     0      0        0 eth0
172.20.96.1     0.0.0.0         255.255.255.255 UH    100    0        0 eth0
```

#### Set  up new bridge
```sh
$ docker network create --driver=bridge --subnet=172.20.96.1/16 vpn

```

#### Test connection using curl
```sh
$ curl --proxy "<ip-machine>:3128" "http://httpbin.org/ip"
```



## Environment variables

This image uses environment variables for configuration.

|Parameter       |Default value                 |Description                      |
|----------------|------------------------------|---------------------------------|
|`image`         |`maciejtrudnos/proxy-vpn`     |Docker image                     |
|`container_name`|`proxy-vpn-container`         |Container name                   |
|`volumes`       |`/path/to/ovpn-files`         |Local path to ovpn files         |
|`ports`         |`3128:3128`                   |Proxy server port                |
|`tty`           |`true`                        |Keep the container running       |
|`cap_add`       |`NET_ADMIN`                   |Enable system network host access|
|`environment`   |`vpn-file-use-to-connect.ovpn`|OpenVPN file used to connect     |
|`dns`           |`-8.8.8.8 -8.8.4.4`           |Google dns network settings      |
