# Copyright © 2017-2023 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

PREFIX = /usr/local
DESTDIR =

bindir = $(PREFIX)/bin
mandir = $(PREFIX)/share/man

.PHONY: all
all: ;

.PHONY: install
install: mbank-cli
	install -d $(DESTDIR)$(bindir)
	install $(<) $(DESTDIR)$(bindir)
ifeq "$(wildcard doc/mbank-cli.1)" ""
	# run "$(MAKE) -C doc" to build the manpage
else
	install -d $(DESTDIR)$(mandir)/man1
	install doc/mbank-cli.1 $(DESTDIR)$(mandir)/man1/$(<).1
endif

.PHONY: test
test:
	prove -v

.PHONY: clean
clean: ;

.error = GNU make is required

# vim:ts=4 sts=4 sw=4 noet
