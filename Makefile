.PHONY: create-vpc destroy-vpc all destroy-all
.SHELL := $(shell which bash)
CURRENT_FOLDER=$(shell basename "$$(pwd)")
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)
terraform:= $(shell command -v terraform 2> /dev/null)
aws:=$(shell command -v aws 2> /dev/null)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-env:
	@if [ -z $(AWS_PROFILE) ]; then \
		echo "$(BOLD)$(RED)AWS_PROFILE was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`AWS_PROFILE=demo make plan\`$(RESET)"; \
		exit 1; \
	 fi

init-demo: cleanup-state set-env ## Init terraform
	@echo "Prepare Backend"
	@echo "$(BOLD)Configuring the terraform backend$(RESET)"
	AWS_PROFILE=$(AWS_PROFILE) terraform init \
				-input=false \
				-reconfigure \
				-lock=true \
				terraform/demo

create-stacks: init-demo ## Create stacks
	@echo "Create Stacks"
	AWS_PROFILE=$(AWS_PROFILE) terraform apply \
				-lock=true \
				-input=false \
				-refresh=true \
				terraform/demo
	
plan-stacks: init-demo ## Plan what will create
	AWS_PROFILE=$(AWS_PROFILE) terraform plan \
				-lock=true \
				-input=false \
				-refresh=true \
				terraform/demo

plan-destroy-stacks: init-demo ## Plan what to destroy
	AWS_PROFILE=$(AWS_PROFILE) terraform plan \
				-input=false \
				-refresh=true \
				-destroy \
				terraform/demo

destroy-stacks: init-demo ## Destroy stacks
	@echo "Destroy VPC"
	AWS_PROFILE=$(AWS_PROFILE) terraform destroy \
				-lock=true \
				-input=false \
				-refresh=true \
				terraform/demo

cleanup-state: ## clean up the local state.
	@echo "Clean up the terraform local state"
	@rm -rf .terraform tf.output

all: create-stacks

destroy-all:  destroy-stacks cleanup-state
