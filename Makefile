# First, define the environment variables that drive EMake.
EENVS  = PACKAGE_FILE="sample.el"
EENVS += PACKAGE_LISP="sample.el"
EENVS += PACKAGE_TESTS="test-sample.el"
EENVS += PACKAGE_ARCHIVES="gnu melpa"
EENVS += PACKAGE_TEST_DEPS="dash buttercup package-lint"
EENVS += PACKAGE_TEST_ARCHIVES="melpa"
# Then, make it easy to invoke Emacs with EMake loaded.
EMAKE := $(EENVS) emacs -batch -l emake.el --eval "(emake (pop argv))"

# Set up our phony targets so Make doesn't think there are files by
# these names.
.PHONY: clean setup install compile test


# Tell Make how to 'clean' this project
clean:				## clean all generated files
	rm -f *.elc		# delete compiled files
	rm -rf .elpa/		# delete dependencies
	rm -rf .elpa.test/
	rm -f emacs-travis.mk	# delete scripts
	rm -f emake.el

## Commands useful for Travis

# Tell Make how to 'setup' this project (e.g., for Travis).  This
# requires both Emacs to be installed and the `emake.el' script to be
# available.
setup: emacs emake.el

# 'install' just means to create the .elpa/ directory (i.e., download dependencies)
install: .elpa/			## install dependencies

# We want to clean before we compile.
compile:			## compile the project
	rm -f *.elc
	$(EMAKE) compile ~error-on-warn

test: test-ert test-buttercup test-package-lint test-checkdoc ## run all tests

## Running specific tests

test-ert: .elpa/		## ERT
	$(EMAKE) test		# could also do $(EMAKE) test ert

test-buttercup: .elpa/		## buttercup
	$(EMAKE) test buttercup

test-checkdoc: .elpa/		## checkdoc
	$(EMAKE) test checkdoc

test-package-lint: .elpa/	## package-lint
	$(EMAKE) test package-lint

## Support targets

# Instruct Make on how to create `emake.el'
emake.el:			## download the EMake script
	wget 'https://raw.githubusercontent.com/vermiculus/emake.el/master/emake.el'

# Instruct Make on how to create `emacs-travis.mk'
emacs-travis.mk:		## download the emacs-travis.mk Makefile
	wget 'https://raw.githubusercontent.com/flycheck/emacs-travis/master/emacs-travis.mk'

# Teach Make that '.elpa/' is created by `(emake "install")'
.elpa/:				## install dependencies as determined by EMake
	$(EMAKE) install

# The following lets you run this Makefile locally without installing
# Emacs over and over again.  On Travis (and other CI services), the
# $CI environment variable is available as "true"; take advantage of
# this to provide two different implementations of the `emacs' target.
ifeq ($(CI),true)
# This is CI.  Emacs may not be available, so install it.
emacs: emacs-travis.mk 		## if CI=true, install Emacs
	export PATH="$(HOME)/bin:$(PATH)"
	make -f emacs-travis.mk install_emacs
else
# This is not CI.  Emacs should already be available.
emacs:				## otherwise, just report the version of Emacs
	which emacs && emacs --version
endif
