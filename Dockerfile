from debian:9
env pas=
run apt update && apt upgrade -y
run apt install shadowsocks-libev -y
expose 443
cmd ss-server -p 443 -k $pas -m aes-256-cfb -u
