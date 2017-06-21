.PHONY: build setup test 

#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
					 %help; \
					 while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
					 print "usage: make [target]\n\n"; \
					 for (sort keys %help) { \
					 print "${WHITE}$$_:${RESET}\n"; \
					 for (@{$$help{$$_}}) { \
					 $$sep = " " x (32 - length $$_->[0]); \
					 print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
					 }; \
					 print "\n"; }

build: ##@build Compiles the project.
	mix compile

setup: ##@setup Installs all needed dependencies
	mix do deps.get, compile, ecto.create, ecto.migrate
	#MIX_ENV=test mix ecto.create

test: ##@test Runs tests
	mix test

#release: ##@dist Builds a release
	#./node_modules/.bin/brunch build --production
	#MIX_ENV=prod mix do compile, phoenix.digest, release

#dialyzer: ##@build Runs type checker
	#mix dialyzer

docs: ##@build Creates docs
	mix docs

help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
