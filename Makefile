# First, define the environment variables that drive EMake.
EENVS := PACKAGE_FILE="sample.el" PACKAGE_LISP="sample.el" PACKAGE_TESTS="test-sample.el" PACKAGE_ARCHIVES="gnu melpa"
# Then, make it easy to invoke Emacs with EMake loaded.
EMAKE := $(EENVS) emacs -batch -l emake.el --eval "(emake (pop argv))"

# Set up our phony targets so Make doesn't think there are files by
# these names.
.PHONY: clean setup install compile test

# Instruct Make on how to create `emake.el'
emake.el:
	wget 'https://raw.githubusercontent.com/vermiculus/emake.el/master/emake.el'

# Instruct Make on how to create `emacs-travis.mk'
emacs-travis.mk:
	wget 'https://raw.githubusercontent.com/flycheck/emacs-travis/master/emacs-travis.mk'

# Tell Make how to 'clean' this project
clean:
	rm -f *.elc		# delete compiled files
	rm -rf .elpa/		# delete dependencies

# Tell Make how to 'setup' this project (e.g., for Travis).  This
# requires both Emacs to be installed and the `emake.el' script to be
# available.
setup: emacs emake.el

# Pass these targets right to EMake.
install test:
	$(EMAKE) $@

# We want to clean before we compile.
compile: clean
	$(EMAKE) compile

# The following lets you run this Makefile locally without installing
# Emacs over and over again.  On Travis (and other CI services), the
# $CI environment variable is available as "true"; take advantage of
# this to provide two different implementations of the `emacs' target.
ifeq ($(CI),true)
emacs: emacs-travis.mk		# This is CI.  Emacs may not be available, so install it.
	export PATH="$(HOME)/bin:$(PATH)"
	make -f emacs-travis.mk install_emacs
else
emacs:				# This is not CI.  Emacs should already be available.
	which emacs && emacs --version
endif
