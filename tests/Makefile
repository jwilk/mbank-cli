.PHONY: test check
test check: server.pem
	ls *.t | xargs -t -d '\n' perl

server.pem: server.rsa server.crt
	cat $(^) > server.pem

server.rsa:
	openssl genrsa -rand /dev/null 2048 > server.rsa

server.crt: server.rsa
	openssl req -x509 -new -key server.rsa -out server.crt \
		-set_serial 0x68f1933f8692ed4b7f58335a073750ac \
		-config server.cnf -sha1

# vim:ts=4 sw=4 noet
