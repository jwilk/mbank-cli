# Copyright © 2014 Jakub Wilk <jwilk@jwilk.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export RANDFILE = /dev/null

.PHONY: all
all: server-self-signed.pem server-default.pem server-wildcard.pem

.PHONY: clean
clean:
	rm -f *.rsa *.req *.crt *.pem *.tmp.cnf

%.pem: %.rsa %.crt
	cat $(^) > $(@)

%.rsa:
	openssl genrsa -out $(@) 2048

x509_options = -sha1 -days 3650
x509_serial = -set_serial 0x400e6045f65210becb18a82eb6c1731e
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

server-self-signed.crt: server-self-signed.rsa server.cnf
	openssl req -x509 -new \
		-key server-self-signed.rsa \
		-config server.cnf \
		$(x509_options) \
		$(x509_serial) \
		-out $(@)

# ===================
# default certificate
# ===================

server-default.req: server-default.rsa server.cnf
	openssl req -new \
		-key server-default.rsa \
		-config server.cnf \
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
	sed -e 's/online[.]/*./g' < $(<) > $(@)

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

# vim:ts=4 sw=4 noet
