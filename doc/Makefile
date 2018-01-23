.PHONY: all
all: mbank-cli.1

.PHONY: clean
clean:
	rm -f *.1 *.tmp

mbank-cli.1: manual.pod
	perl -p -e 's/L<([a-z_-]+)[(]([0-9]+)[)]>/B<\1>(\2)/g' $(<) \
	| pod2man --utf8 -q none -c '' -n mbank-cli -r mbank-cli \
	> $(@).tmp
	mv $(@).tmp $(@)

# vim:ts=4 sts=4 sw=4 noet
