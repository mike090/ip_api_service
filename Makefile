install:
	bundle install

test:
	rake test

lint:
	rubocop lib/	

.PHONY: test