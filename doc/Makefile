name = mbank-cli
uname = $(shell echo $(name) | LC_ALL=C tr a-z A-Z)
version = $(shell head -n1 NEWS | cut -d ' ' -f2 | tr -d '()')

.PHONY: all
all: mbank-cli.1

.PHONY: clean
clean:
	rm -f *.1 *.tmp

mbank-cli.1: manual.pod
	perl -p -e 's/L<([a-z_-]+)[(]([0-9]+)[)]>/B<\1>(\2)/g' $(<) \
	| pod2man --utf8 -q none -c '' -n $(uname) -r '$(name) $(version)' \
	> $(@).tmp
	mv $(@).tmp $(@)

.PHONY: test check
test check: manual.pod
	podchecker -warnings -warnings $(<)

# vim:ts=4 sts=4 sw=4 noet
