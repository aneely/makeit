PREFIX     ?= ~/.local
CONFIG_DIR ?= $(HOME)/.config/makeit

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
	@echo "  init is not yet available — scaffold files are not built yet."

.PHONY: install uninstall test init
