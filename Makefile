OUTPUT_DIR := target
SHELL := /bin/bash

all: applescript open-note-app jxa workflows
clean:
	rm -rf $(OUTPUT_DIR)

applescript: src/*/*.applescript
	mkdir -p $(OUTPUT_DIR)/scripts;
	for script in $^; do \
		filename=$$(basename $$script | sed -E s/\.[^.]+$$//); \
		echo $$filename; \
		osacompile -o $(OUTPUT_DIR)/scripts/$$filename.scpt $$script; \
	done

open-note-app: src/notes/open_note_url.app
	mkdir -p $(OUTPUT_DIR)/scripts;
	for script_app in $^; do \
		filename=$$(basename $$script_app); \
		osacompile -o $(OUTPUT_DIR)/scripts/$$filename $$script_app/main.applescript; \
		cp -rf $$script_app/Contents $(OUTPUT_DIR)/scripts/$$filename/; \
	done

jxa: src/*/*.js
	mkdir -p $(OUTPUT_DIR)/scripts;
	for script in $^; do \
		filename=$$(basename $$script | sed -E s/\.[^.]+$$//); \
		echo $$filename; \
		osacompile -l JavaScript -o $(OUTPUT_DIR)/scripts/$$filename.scpt $$script; \
	done

workflows: src/alfred/*
	mkdir -p $(OUTPUT_DIR)/workflows;
	for workflow in $^; do \
		filename=$(OUTPUT_DIR)/workflows/$$(basename $$workflow); \
		rm -f $$filename; \
		zip $$filename -j -r $$workflow; \
	done
