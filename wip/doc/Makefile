.PHONY: all
all: mbank-cli.1

.PHONY: clean
clean:
	rm -f *.1

mbank-cli.1: manual.pod
	sed -e 's/L<\([a-z_-]\+\)(\([0-9]\+\))>/B<\1>(\2)/g' $(<) \
	| pod2man --utf8 -q none -c '' -n mbank-cli -r mbank-cli \
	> $(@).tmp
	mv $(@).tmp $(@)

# vim:ts=4
