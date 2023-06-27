# Copyright © 2009-2023 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

version = $(shell head -n1 NEWS | cut -d ' ' -f2 | tr -d '()')

rst2xml = $(notdir $(shell command -v rst2xml || echo rst2xml.py)) \
	--input-encoding=UTF-8 \
	--strict

.PHONY: all
all: mbank-cli.1

.PHONY: clean
clean:
	rm -f *.1 *.tmp

mbank-cli.1: manual.pod
	perl -p -e 's/L<([a-z_-]+)[(]([0-9]+)[)]>/B<\1>(\2)/g' $(<) \
	| pod2man --utf8 -q none -c '' -n MBANK-CLI -r 'mbank-cli $(version)' \
	> $(@).tmp
	mv $(@).tmp $(@)

.PHONY: check
check: check-news check-pod check-rst

.PHONY: check-news
check-news: NEWS
	dpkg-parsechangelog -l$(<) --all 2>&1 >/dev/null | { ! grep .; }

.PHONY: check-pod
check-pod: manual.pod
	podchecker -warnings -warnings $(<)

.PHONY: check-rst
check-rst:
	grep -rwl 'ft[=]rst' | xargs -t -I{} $(rst2xml) {} > /dev/null

.error = GNU make is required

# vim:ts=4 sts=4 sw=4 noet
