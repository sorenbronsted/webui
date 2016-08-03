.PHONY:	test

SHELL=/bin/bash

all: test
	echo "Up-to-date"

test:
	/usr/lib/dart/bin/pub run test test