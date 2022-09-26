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

clone:       		## # clone all the github for target organisation
	curl "https://api.github.com/orgs/${ORGANISATION}/repos?per_page=1000" | grep -o 'git@[^"]*' | xargs -L1 git clone

refresh:			## # refresh the current dircetory repos
	find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$(PWD)/{} pull \;

git-status-check:   ## # check uncommited changes
	@if git diff --quiet HEAD --; \
	then\
		echo "Git status check passed. Beginning build";\
	else\
		echo "[ERROR] Uncommitted changes detected, build aborted";\
		false;\
	fi