XSL = http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl

.PHONY: all
all: mbank-cli.1

.PHONY: clean
clean:
	rm -f *.1

%.1: %.xml
	xsltproc --nonet $(XSL) $(<)
	sed -i \
		-e "s,\([0-9][0-9]\)/\([0-9][0-9]\)/\([0-9][0-9][0-9][0-9]\),\3-\1-\2," \
		$(@)

# vim:ts=4
