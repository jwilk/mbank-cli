.PHONY: test check
test check: server.pem
	ls *.t | xargs -t -d '\n' perl

server.pem: server.rsa server.crt
	cat $(^) > server.pem

server.rsa:
	openssl genrsa -rand /dev/null 2048 > server.rsa

server.crt: server.rsa
	openssl req -x509 -new -key server.rsa -out server.crt -batch \
	-subj '/businessCategory=Private Organization/serialNumber=0000025237/C=PL/postalCode=00-950/ST=mazowieckie/L=Warszawa/street=Senatorska 18/O=mBank S.A./OU=DIN/CN=mbank/'
	# TODO: add /jurisdictionOfIncorporationCountryName=PL/ to the subject

# vim:ts=4 sw=4 noet
