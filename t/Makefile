.PHONY: test check
test check: server.pem
	cd .. && prove -v

server.pem: server.rsa server.crt
	cat $(^) > server.pem

server.rsa:
	openssl genrsa -rand /dev/null 2048 > server.rsa

server.crt: server.rsa
	openssl req -x509 -new -key server.rsa -out server.crt \
		-days 3650 \
		-set_serial 0x400e6045f65210becb18a82eb6c1731e \
		-config server.cnf -sha1

# vim:ts=4 sw=4 noet
