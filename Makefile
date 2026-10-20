SUBMODULE := lazygit
PATCH     := pr-tab.patch
TAG       ?=

.PHONY: setup update patch unpatch diff

setup:
	git submodule update --init $(SUBMODULE)

# Checks out the lazygithub TAG (current HEAD if unset) and its lazygit commit
update:
ifneq ($(TAG),)
	git fetch --tags origin
	git checkout --quiet $(TAG)
endif
	git submodule update --init $(SUBMODULE)

patch:
	git -C $(SUBMODULE) apply --3way ../$(PATCH)

unpatch:
	git -C $(SUBMODULE) apply -R ../$(PATCH)
	git -C $(SUBMODULE) reset --quiet

# Regenerates the patch from lazygit's working tree, new files included
diff:
	git -C $(SUBMODULE) add --intent-to-add .
	git -C $(SUBMODULE) diff HEAD > $(PATCH)
