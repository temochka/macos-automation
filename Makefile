OUTPUT_DIR := target
SHELL := /bin/bash

all: applescript-automation open-note-app jxa-automation alfred-workflow
clean:
	rm -rf $(OUTPUT_DIR)

install:
	cp $(OUTPUT_DIR)/cli/ical-* ~/bin/

applescript-automation: applescript/*/*.applescript
	mkdir -p $(OUTPUT_DIR)/scripts;
	for script in $^; do \
		filename=$$(basename $$script | sed -E s/\.[^.]+$$//); \
		echo $$filename; \
		cat applescript/lib.applescript $$script | osacompile -o $(OUTPUT_DIR)/scripts/$$filename.scpt; \
	done

open-note-app: applescript/notes/open_note_url.app
	mkdir -p $(OUTPUT_DIR)/scripts;
	for script_app in $^; do \
		filename=$$(basename $$script_app); \
		cat applescript/lib.applescript $$script_app/main.applescript | osacompile -o $(OUTPUT_DIR)/scripts/$$filename; \
		cp -rf $$script_app/Contents $(OUTPUT_DIR)/scripts/$$filename/; \
		codesign --force --deep -s - $(OUTPUT_DIR)/scripts/$$filename; \
	done

jxa-automation: applescript/*/*.js
	mkdir -p $(OUTPUT_DIR)/scripts;
	for script in $^; do \
		filename=$$(basename $$script | sed -E s/\.[^.]+$$//); \
		echo $$filename; \
		osacompile -l JavaScript -o $(OUTPUT_DIR)/scripts/$$filename.scpt $$script; \
	done

alfred-workflow: AlfredProcess
	mkdir -p $(OUTPUT_DIR);
	$(MAKE) -C $^;
	rm -f $(OUTPUT_DIR)/Process.alfredworkflow;
	(cd $^ && zip ../$(OUTPUT_DIR)/Process.alfredworkflow -r . --exclude src/\* --exclude .\* --exclude Makefile);

sync-alfred-workflow: Process.alfredworkflow
	rm -rf AlfredProcess;
	unzip -d AlfredProcess $^;
	$(MAKE) clean -C AlfredProcess;
