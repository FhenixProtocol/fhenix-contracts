.PHONY: install
install:
	npm i

.PHONY: gen_console
gen_console: install
	npx ts-node ./scripts/genConsole.ts


.PHONY: gen
gen: gen_console
	

