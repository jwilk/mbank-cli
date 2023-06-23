# Copyright © 2014-2023 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

export RANDFILE = /dev/null

JCN = $(shell openssl asn1parse < jurisdictionCountryName.asn1 | grep -o -w jurisdictionCountryName)

.PHONY: all
all: server-self-signed.pem server-default.pem server-wildcard.pem

.PHONY: clean
clean:
	rm -f *.rsa *.req *.crt *.pem *.tmp.cnf

%.pem: %.rsa %.crt
	cat $(^) > $(@)

%.rsa:
	openssl genrsa -out $(@) 2048

x509_options = -sha256 -days 3650
x509_serial = -set_serial 0x400E6045
x509_req_ext = -extensions x509_ext -extfile

# =====================
# certificate authority
# =====================

ca.crt: ca.rsa ca.cnf
	openssl req -x509 -new \
		-key ca.rsa \
		-config ca.cnf \
		$(x509_options) \
		-out $(@)

# =======================
# self-signed certificate
# =======================

server-self-signed.tmp.cnf: server.cnf
	sed -e '/^$(JCN) = [0-9]/d' < $(<) > $(@)

server-self-signed.crt: server-self-signed.rsa server-self-signed.tmp.cnf
	openssl req -x509 -new \
		-key server-self-signed.rsa \
		-config server-self-signed.tmp.cnf \
		$(x509_options) \
		$(x509_serial) \
		-out $(@)

# ===================
# default certificate
# ===================

server-default.tmp.cnf: server.cnf
	sed -e '/^$(JCN) = [0-9]/d' < $(<) > $(@)

server-default.req: server-default.rsa server-default.tmp.cnf
	openssl req -new \
		-key server-default.rsa \
		-config server-default.tmp.cnf \
		$(x509_options) \
		-out $(@)

server-default.crt: server-default.req server.cnf ca.pem
	openssl x509 -req -CA ca.pem \
		$(x509_options) \
		$(x509_serial) \
		$(x509_req_ext) server.cnf \
		-in $(<) \
		-out $(@)

# ====================
# wildcard certificate
# ====================

server-wildcard.tmp.cnf: server.cnf
	sed -e '/^$(JCN) = [0-9]/d' -e 's/online[.]/*./g' < $(<) > $(@)

server-wildcard.req: server-wildcard.rsa server-wildcard.tmp.cnf
	openssl req -new \
		-key server-wildcard.rsa \
		-config server-wildcard.tmp.cnf \
		$(x509_options) \
		-out $(@)

server-wildcard.crt: server-wildcard.req server-wildcard.tmp.cnf ca.pem
	openssl x509 -req -CA ca.pem \
		$(x509_options) \
		$(x509_serial) \
		$(x509_req_ext) server-wildcard.tmp.cnf \
		-in $(<) \
		-out $(@)

.error = GNU make is required

# vim:ts=4 sts=4 sw=4 noet
