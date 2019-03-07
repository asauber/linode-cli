#
# Makefile for more convenient building of the Linode CLI and its baked content
#

PYTHON ?= 3
SPEC ?= https://developers.linode.com/api/v4/openapi.yaml

ifeq ($(PYTHON), 3)
	PYCMD=python3
	PIPCMD=pip3
else
	PYCMD=python2
	PIPCMD=pip2
endif

install: check-prerequisites requirements build
	ls dist/ | xargs -I{} $(PIPCMD) install --force dist/{}

.PHONY: build
build: clean
	python2 -m linodecli bake ${SPEC} --skip-config
	python3 -m linodecli bake ${SPEC} --skip-config
	cp data-2 linodecli/
	cp data-3 linodecli/
	$(PYCMD) setup.py bdist_wheel --universal

.PHONY: requirements
requirements:
	pip2 install -r requirements.txt
	pip3 install -r requirements.txt

.PHONY: check-prerequisites
check-prerequisites:
	@ pip2 -v >/dev/null
	@ pip3 -v >/dev/null
	@ python2 -V >/dev/null
	@ python3 -V >/dev/null

.PHONY: clean
clean:
	rm -f linodecli/data-*
	rm -f linode-cli.sh
	rm -f dist/*
