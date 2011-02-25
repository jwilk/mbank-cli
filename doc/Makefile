XSL = http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl

.PHONY: all
all: mbank-cli.1

.PHONY: clean
clean:
	rm -f *.1

%.1: %.xml
	xsltproc $(XSL) $(<)
	sed -i -e "s/\\\\'/\\\\(aq/g" $(@)

# vim:ts=4
