XSL = http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl

.PHONY: all
all: mbank-cli.1

%.1: %.xml
	xsltproc $(XSL) $(<)

# vim:ts=4
