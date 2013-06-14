
.PHONY: build compile clean haml sass coffee resources deploy

MINIFY := juicer -q merge -s
MINIFY_DEBUG := juicer -q merge -m none -s

build:
	@$(MAKE) clean
	@echo "Copying resources..."
	@$(MAKE) resources
	@echo "Compiling..."
	@$(MAKE) compile
	@echo "=> Game built!"

resources:
	@mkdir -p output
	@cp -rf resources/* output/

compile: haml sass coffee

haml:
	@haml haml/index.haml output/index.html

sass:
	@sass sass/spooky.sass output/spooky.css
	@$(MINIFY) output/spooky.css
	@rm -f output/spooky.css

coffee:
	coffee -o output/ -c coffee/
	@$(MINIFY_DEBUG) output/spooky.js
	@rm -f output/spooky.js

clean:
	@mkdir -p output
	@rm -rf output/*

