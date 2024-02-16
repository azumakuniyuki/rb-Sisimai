# rb-sisimai/Makefile
#  __  __       _         __ _ _      
# |  \/  | __ _| | _____ / _(_) | ___ 
# | |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | |  | | (_| |   <  __/  _| | |  __/
# |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
# -----------------------------------------------------------------------------
SHELL := /bin/sh
TIME  := $(shell date '+%s')
NAME  := sisimai
RUBY  ?= ruby
JRUBY ?= /usr/local/jr
RAKE  ?= rake
MKDIR := mkdir -p
RSPEC := rspec -Ilib -f progress
CP    := cp
RM    := rm -f

DEPENDENCIES  = bundle rake rspec
.DEFAULT_GOAL = git-status
REPOS_TARGETS = git-status git-push git-commit-amend git-tag-list git-diff \
				git-reset-soft git-rm-cached git-branch
DEVEL_TARGETS = private-sample
BENCH_TARGETS = profile speed-test loc


# -----------------------------------------------------------------------------
.PHONY: clean

depend:
	gem install $(DEPENDENCIES)
	if [ -d "$(JRUBY)" ]; then \
		PATH="$(JRUBY)/bin:$$PATH" $(JRUBY)/bin/gem install $(DEPENDENCIES); \
	fi

install-from-rubygems:
	gem install $(NAME)
	if [ -d "$(JRUBY)" ]; then \
		PATH="$(JRUBY)/bin:$$PATH" $(JRUBY)/bin/gem install $(NAME); \
	fi

install-from-local:
	$(RAKE) install
	if [ -d "$(JRUBY)" ]; then \
		PATH="$(JRUBY)/bin:$$PATH" $(JRUBY)/bin/rake install; \
	fi

build:
	$(RAKE) $@ 
	if [ -d "$(JRUBY)" ]; then \
		PATH="$(JRUBY)/bin:$$PATH" $(JRUBY)/bin/rake $@; \
	fi

release:
	$(RAKE) release
	if [ -d "$(JRUBY)" ]; then \
		PATH="$(JRUBY)/bin:$$PATH" $(JRUBY)/bin/rake release; \
	fi

test: cruby-test

check:
	find lib -type f -exec grep --color -E ' $$' {} /dev/null \;
	find lib -type f -exec grep --color -E '[;][ ]*$$' {} /dev/null \;

cruby-test:
	$(RAKE) spec

jruby-test:
	if [ -d "$(JRUBY)" ]; then \
		PATH="$(JRUBY)/bin:$$PATH" LS_HEAP_SIZE='1024m' $(JRUBY)/bin/rake spec; \
	fi

patrol:
	rubocop -fp --display-cop-names --display-style-guide --no-color lib

$(REPOS_TARGETS):
	$(MAKE) -f Repository.mk $@

$(DEVEL_TARGETS):
	$(MAKE) -f Developers.mk $@

$(BENCH_TARGETS):
	$(MAKE) -f Benchmarks.mk $@

diff push branch:
	@$(MAKE) git-$@
fix-commit-message: git-commit-amend
cancel-the-latest-commit: git-reset-soft
remove-added-file: git-rm-cached

clean:
	$(MAKE) -f Repository.mk clean
	$(MAKE) -f Benchmarks.mk clean

