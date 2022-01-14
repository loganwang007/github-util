# sets makefile to use bash, rather than the default sh
SHELL=/bin/bash
# respect .bashrc, fail on error
.SHELLFLAGS=-lec
# commands run consecutively in the same shell, variables can persist in a target
.ONESHELL:

# never skip any make targets, effectively disables "change detection"
.PHONY: $(MAKECMDGOALS)

pwd = pwd

help:				## # Show this help
	@echo "Usage:"
	@sed -ne '/@sed/!s/:.*## / /p' $(MAKEFILE_LIST) \
		| sed 's/^/  make /' \
		| column -s "#" -t

pull:       		## # pull all the github for target organisation
	curl -s https://api.github.com/orgs/${ORGANISATION}/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

refresh:			## # refresh the current dircetory repos
	find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$(pwd)/{} pull origin main \;

git-status-check:   ## # check uncommited changes
	@if git diff --quiet HEAD --; \
	then\
		echo "Git status check passed. Beginning build";\
	else\
		echo "[ERROR] Uncommitted changes detected, build aborted";\
		false;\
	fi