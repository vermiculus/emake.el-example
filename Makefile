# EMACS_VERSION should be set in your ~/.profile on your development machine
EMACS_VERSION         ?= 26.3
EMAKE_SHA1            ?= 5936c6cfd7e9f2aa94ae6a49f614e22c15dc449f
PACKAGE_BASENAME      := sample

# override defaults
PACKAGE_ARCHIVES      := gnu melpa
PACKAGE_TEST_DEPS     := dash
PACKAGE_TEST_ARCHIVES := gnu melpa

#EMACS_ARGS += --eval '(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")'
#EMACS_ARGS += --eval "(require 'gnutls)"

.DEFAULT_GOAL: help

emake.mk:                       ## download the emake Makefile
	wget 'https://raw.githubusercontent.com/vermiculus/emake.el/$(EMAKE_SHA1)/emake.mk'

ifeq ($(TRAVIS_OS_NAME),osx)
export EMACS_CONFIGURE_ARGS := --with-ns --with-modules
endif

setup: emacs emake.mk

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
	bash -e <(curl -fsSkL 'https://raw.githubusercontent.com/vermiculus/emake.el/$(EMAKE_SHA1)/build-emacs')

clean:
	rm -rf $(EMAKE_WORKDIR)
	rm -f $(PACKAGE_LISP:.el=.elc)

include emake.mk
