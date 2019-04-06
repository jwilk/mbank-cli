# Copyright © 2009-2018 Jakub Wilk <jwilk@jwilk.net>
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
	grep -rwl 'ft[=]rst' | xargs -t -I{} $(rst2xml) {} /dev/null

.error = GNU make is required

# vim:ts=4 sts=4 sw=4 noet
