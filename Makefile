OUTPUT_DIR := target
SHELL := /bin/bash
APPLESCRIPT := applescript/*/*.applescript
JXA := applescript/*/*.js
LAUNCHERS := applescript/*/launcher.json

all: launchers applescript-automation jxa-automation open-note-app  alfred-workflow ical-alfred hotkeys
install:
	cp $(OUTPUT_DIR)/cli/* ~/bin/
clean:
	rm -rf $(OUTPUT_DIR)

target-dir:
	mkdir -p $(OUTPUT_DIR)/applescript;
	mkdir -p $(OUTPUT_DIR)/apps;
	mkdir -p $(OUTPUT_DIR)/cli;
	mkdir -p $(OUTPUT_DIR)/hotkeys;
	for dir in $$(find applescript -mindepth 1 -maxdepth 1 -not -type f); do \
		mkdir -p $(OUTPUT_DIR)/applescript/$$(basename $$dir); \
	done

launchers: target-dir $(LAUNCHERS)
	mkdir -p $(OUTPUT_DIR)/applescript;
	for launcher in $(LAUNCHERS); do \
		cp $$launcher target/$$launcher; \
	done

applescript-automation: target-dir $(APPLESCRIPT)
	for script in $(APPLESCRIPT); do \
		dirname=$$(dirname $$script | sed -E s/.*\\///); \
		filename=$$(basename $$script | sed -E s/\.[^.]+$$//); \
		echo $$filename; \
		cat applescript/lib.applescript $$script | osacompile -o $(OUTPUT_DIR)/applescript/$$dirname/$$filename.scpt; \
	done

jxa-automation: target-dir $(JXA)
	for script in $(JXA); do \
		dirname=$$(dirname $$script | sed -E s/.*\\///); \
		filename=$$(basename $$script | sed -E s/\.[^.]+$$//); \
		echo $$filename; \
		osacompile -l JavaScript -o $(OUTPUT_DIR)/applescript/$$dirname/$$filename.scpt $$script; \
	done

open-note-app: apps/*
	for script_app in $^; do \
		filename=$$(basename $$script_app); \
		cat applescript/lib.applescript $$script_app/main.applescript | osacompile -o $(OUTPUT_DIR)/apps/$$filename; \
		cp -rf $$script_app/Contents $(OUTPUT_DIR)/apps/$$filename/; \
		codesign --force --deep -s - $(OUTPUT_DIR)/apps/$$filename; \
	done

alfred-workflow: AlfredProcess
	mkdir -p $(OUTPUT_DIR);
	rm -f $(OUTPUT_DIR)/Process.alfredworkflow;
	(cd $^ && zip ../$(OUTPUT_DIR)/Process.alfredworkflow -r . --exclude .\*);

sync-alfred-workflow: Process.alfredworkflow
	rm -rf AlfredProcess;
	unzip -d AlfredProcess $^;

ical-alfred: target-dir cli/ical-alfred.swift
	@xcrun swiftc -sdk $(shell xcrun --show-sdk-path --sdk macosx) -o $(OUTPUT_DIR)/cli/ical-alfred cli/ical-alfred.swift
	chmod +x $(OUTPUT_DIR)/ical-alfred

hotkeys: target-dir applescript hotkeys/Anykey.base.json
	./hotkeys/build.rb > $(OUTPUT_DIR)/hotkeys/Anykey.json
