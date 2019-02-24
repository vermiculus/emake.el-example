# EMACS_VERSION should be set in your ~/.profile on your development machine
EMACS_VERSION         ?= 26.1
EMAKE_SHA1            ?= 4a42b2d8a2fb775389a3e6092924c6a25173a81e
PACKAGE_BASENAME      := sample

# override defaults
PACKAGE_ARCHIVES      := gnu melpa
PACKAGE_TEST_DEPS     := dash
PACKAGE_TEST_ARCHIVES := gnu melpa

.DEFAULT_GOAL: help

emake.mk:                       ## download the emake Makefile
	wget 'https://raw.githubusercontent.com/vermiculus/emake.el/$(EMAKE_SHA1)/emake.mk'

ifeq ($(TRAVIS_OS_NAME),osx)
# Additional dependencies were installed by the Homebrew add-on
export PATH := /usr/local/opt/texinfo/bin:$(PATH)
export EMACS_CONFIGURE_ARGS := --prefix=$(EMACS_INSTALL_DESTINATION) --with-ns --with-modules
endif

setup: emacs

emacs: SHELL := /bin/bash
emacs:
ifeq ($(TRAVIS_OS_NAME),osx)
# Mac needs some extra love.
	-mkdir -p /tmp/emacs-$(EMACS_VERSION)
	-cp -R $(EMACS_INSTALL_DESTINATION)/ /tmp/emacs-$(EMACS_VERSION)
endif
	bash -e <(curl -fsSkL 'https://raw.githubusercontent.com/vermiculus/emake.el/$(EMAKE_SHA1)/install-emacs')
ifeq ($(TRAVIS_OS_NAME),osx)
	-mkdir -p $(EMACS_INSTALL_DESTINATION)/bin
	-cp -R /tmp/emacs-$(EMACS_VERSION)/ $(EMACS_INSTALL_DESTINATION)
	-ln -s $(EMACS_INSTALL_DESTINATION)/nextstep/Emacs.app/Contents/MacOS/Emacs $(EMACS_INSTALL_DESTINATION)/bin/emacs
endif

clean:
	rm -rf $(EMAKE_WORKDIR)
	rm -f $(PACKAGE_LISP:.el=.elc)

include emake.mk
