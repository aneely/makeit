test:
	@shopt -s nullglob; \
	files=$$(echo tests/*_test.lua); \
	if [ -z "$$files" ]; then \
		echo "no test files found in tests/"; \
	else \
		for f in $$files; do lua "$$f"; done; \
	fi

.PHONY: test
