from ubuntu:16.10
env pas=
run apt-get update
run apt-get install -y shadowsocks-libev
expose 443
cmd ss-server -p 443 -k $pas -m aes-256-cfb -u
