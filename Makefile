# EMACS_VERSION should be set in your ~/.profile on your development machine
EMACS_VERSION         ?= 26.1
EMAKE_SHA1            ?= fbbbf2bd60785337a7369de08d4e6c6256e5c03e
PACKAGE_BASENAME      := sample

# override defaults
PACKAGE_ARCHIVES      := gnu melpa
PACKAGE_TEST_DEPS     := dash
PACKAGE_TEST_ARCHIVES := gnu melpa

.DEFAULT_GOAL: help

emake.mk:                       ## download the emake Makefile
	wget 'https://raw.githubusercontent.com/vermiculus/emake.el/$(EMAKE_SHA1)/emake.mk'

ifeq ($(TRAVIS_OS_NAME),osx)
export EMACS_CONFIGURE_ARGS := --with-ns --with-modules
endif

setup: emacs

travis-script:
# test uncompiled
	$(MAKE) test-ert
	$(MAKE) test-buttercup
# test compilation
	$(MAKE) compile
# test compiled
	$(MAKE) test-ert
	$(MAKE) test-buttercup
# linting
	$(MAKE) lint-package-lint
	$(MAKE) lint-checkdoc

emacs: SHELL := /bin/bash
emacs:
	bash -e <(curl -fsSkL 'https://raw.githubusercontent.com/vermiculus/emake.el/$(EMAKE_SHA1)/install-emacs')

clean:
	rm -rf $(EMAKE_WORKDIR)
	rm -f $(PACKAGE_LISP:.el=.elc)

include emake.mk
