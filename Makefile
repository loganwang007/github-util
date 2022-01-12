# sets makefile to use bash, rather than the default sh
SHELL=/bin/bash
# respect .bashrc, fail on error
.SHELLFLAGS=-lec
# commands run consecutively in the same shell, variables can persist in a target
.ONESHELL:

# never skip any make targets, effectively disables "change detection"
.PHONY: $(MAKECMDGOALS)

help:				## # Show this help
	@echo "Usage:"
	@sed -ne '/@sed/!s/:.*## / /p' $(MAKEFILE_LIST) \
		| sed 's/^/  make /' \
		| column -s "#" -t


pull:       		## # pull all the github for target organisation
	curl -s https://api.github.com/orgs/${ORGANISATION}/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'