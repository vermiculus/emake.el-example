# EMACS_VERSION should be set in your ~/.profile on your development machine
EMACS_VERSION         ?= 26.1
EMAKE_SHA1            ?= f3a676670e185c17bfd56c281e7e01774860b1e4
PACKAGE_BASENAME      := sample

# override defaults
PACKAGE_ARCHIVES      := gnu melpa
PACKAGE_TEST_DEPS     := dash
PACKAGE_TEST_ARCHIVES := gnu melpa

.DEFAULT_GOAL: help

emake.mk:                       ## download the emake Makefile
	wget 'https://raw.githubusercontent.com/vermiculus/emake.el/$(EMAKE_SHA1)/emake.mk'

clean:
	rm -rf $(EMAKE_WORKDIR)
	rm -f $(PACKAGE_LISP:.el=.elc)

include emake.mk
