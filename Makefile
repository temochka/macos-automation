OUTPUT_DIR := target
SHELL := /bin/bash

all: applescript open-note-app jxa workflows ical-now
clean:
	rm -rf $(OUTPUT_DIR)

applescript: applescript/*/*.applescript
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

jxa: applescript/*/*.js
	mkdir -p $(OUTPUT_DIR)/scripts;
	for script in $^; do \
		filename=$$(basename $$script | sed -E s/\.[^.]+$$//); \
		echo $$filename; \
		osacompile -l JavaScript -o $(OUTPUT_DIR)/scripts/$$filename.scpt $$script; \
	done

workflows: alfred/*
	mkdir -p $(OUTPUT_DIR)/workflows;
	for workflow in $^; do \
		filename=$(OUTPUT_DIR)/workflows/$$(basename $$workflow); \
		rm -f $$filename; \
		zip $$filename -j -r $$workflow; \
	done

ical-now: cli/ical-now/main.swift
	mkdir -p $(OUTPUT_DIR)/cli;
	@xcrun swiftc -sdk $(shell xcrun --show-sdk-path --sdk macosx) -o $(OUTPUT_DIR)/cli/ical-now $^;
	chmod +x $(OUTPUT_DIR)/cli/ical-now

