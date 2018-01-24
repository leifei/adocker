from ubuntu:16.10
env pas=
run apt update & apt install snap -y
run snap install shadowsocks-libev
expose 443
cmd ss-server -p 443 -k $pas -m aes-256-cfb -u
