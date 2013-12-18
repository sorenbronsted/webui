.PHONY:	checkout

SHELL=/bin/bash

all: checkout
	echo "Up-to-date"

checkout:
	git pull

