from debian:9
env pas=
run apt update & apt install shadowsocks-libev
expose 2080
cmd ss-server -p 443 -k $pas -m aes-256-cfb -u
