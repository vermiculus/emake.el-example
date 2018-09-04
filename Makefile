# EMACS_VERSION should be set in your ~/.profile on your development machine
EMAKE_SHA1            := 4208a5e4e68c0e13ecd57195209bdeaf5959395f
PACKAGE_BASENAME      := sample

# override defaults
PACKAGE_ARCHIVES      := gnu melpa
PACKAGE_TEST_DEPS     := dash
PACKAGE_TEST_ARCHIVES := gnu melpa

.DEFAULT_GOAL: help

emake.mk:                       ## download the emake Makefile
	wget 'https://raw.githubusercontent.com/vermiculus/emake.el/$(EMAKE_SHA1)/emake.mk'

include emake.mk
