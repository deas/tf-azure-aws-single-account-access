.DEFAULT_GOAL := help
HELP-DESCRIPTION-SPACING := 24

# Dump vs. dumpall?
# az ad app list
# az ad app show --id a053dab5-28ad-4c7d-bd44-c317fbdbf2ba
# az ad sp list --query "[?contains(tags, 'WindowsAzureActiveDirectoryIntegratedApp')]" --all
# az ad sp show --id e2749d43-6d63-450e-99cb-bcf6cef0829

# ------- Help ----------------------- #
# Source: https://nedbatchelder.com/blog/201804/makefile_help_target.html

help:  ## Describe available tasks in Makefile
#	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) |
	@grep '^[a-zA-Z]' Makefile | \
	sort | \
	awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-$(HELP-DESCRIPTION-SPACING)s\033[0m %s\n", $$1, $$2}'


.PHONY: sample
sample: ## Sample
	echo ""
