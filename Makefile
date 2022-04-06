test:
	test -s solution
install:
	bundle install
tdd:
	rake test

.PHONY: test