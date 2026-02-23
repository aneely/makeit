PREFIX             ?= ~/.local
DEFAULT_CONFIG_DIR ?= $(HOME)/.config/makeit
CONFIG_DIR         ?= $(DEFAULT_CONFIG_DIR)

install:
	install -d $(PREFIX)/bin
	install -m 755 bin/makeit $(PREFIX)/bin/makeit
	@command -v hs >/dev/null 2>&1 || \
		echo "  warning: hs not found. Open Hammerspoon → Console and run: hs.ipc.cliInstall()"

uninstall:
	rm -f $(PREFIX)/bin/makeit

test:
	bats tests/*.bats

init:
	mkdir -p $(CONFIG_DIR)/tests
	@if [ ! -f $(CONFIG_DIR)/work.lua ]; then \
		cp scaffold/work.lua $(CONFIG_DIR)/work.lua; \
		echo "  Created $(CONFIG_DIR)/work.lua"; \
	fi
	@if [ ! -f $(CONFIG_DIR)/tests/work_test.lua ]; then \
		cp scaffold/work_test.lua $(CONFIG_DIR)/tests/work_test.lua; \
		echo "  Created $(CONFIG_DIR)/tests/work_test.lua"; \
	fi
	@if [ ! -f $(CONFIG_DIR)/Makefile ]; then \
		cp scaffold/config.Makefile $(CONFIG_DIR)/Makefile; \
		echo "  Created $(CONFIG_DIR)/Makefile"; \
	fi
	@if [ "$(CONFIG_DIR)" != "$(DEFAULT_CONFIG_DIR)" ]; then \
		echo "  Add to your .zshrc: export MAKEIT_CONFIG=$(CONFIG_DIR)"; \
	fi
	@echo "  Done. To version-control your profiles:"
	@echo "    cd $(CONFIG_DIR) && git init && git add . && git commit -m \"initial profiles\""
	@echo "  Then: makeit work"

.PHONY: install uninstall test init
