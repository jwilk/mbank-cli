export RANDFILE = /dev/null

.PHONY: test check
test check: server.pem
	cd .. && prove -v

server.pem: server.rsa server.crt
	cat $(^) > server.pem

server.rsa:
	openssl genrsa 2048 > server.rsa

server.crt: server.rsa
	openssl req -x509 -new -key server.rsa -out server.crt \
		-days 3650 \
		-set_serial 0x68f1933f8692ed4b7f58335a073750ac \
		-config server.cnf -sha1

# vim:ts=4 sts=4 sw=4 noet
