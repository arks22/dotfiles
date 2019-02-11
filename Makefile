DOTPATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
EXCLUSIONS := .DS_Store .git .gitignore
DOTFILES   := $(filter-out $(EXCLUSIONS), $(wildcard .*))

all:

deploy:
	@echo "deploy dotifiles..."
	@bash $(DOTPATH)/manage/deploy.sh $(DOTFILES)

uninstall:
	@echo "uninstall dotifiles..."
	@bash $(DOTPATH)/manage/uninstall.sh $(DOTFILES)

update:
	@echo "update dotifiles..."
	@git pull origin master

init:
	@echo "init dotifiles..."
	@bash $(DOTPATH)/manage/init.sh
