OUTPUT_DIR := target
SHELL := /bin/bash
APPLESCRIPT := applescript/*/*.applescript
JXA := applescript/*/*.js
LAUNCHERS := applescript/*/launcher.json

all: launchers applescript-automation jxa-automation alfred-workflow ical-alfred pb hotkeys
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

launchers: target-dir applescript/meta_launcher.rb $(LAUNCHERS)
	mkdir -p $(OUTPUT_DIR)/applescript;
	for launcher in $(LAUNCHERS); do \
		cp $$launcher target/$$launcher; \
	done
	./applescript/meta_launcher.rb > $(OUTPUT_DIR)/applescript/meta_launcher.json

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

alfred-workflow: AlfredProcess
	mkdir -p $(OUTPUT_DIR);
	rm -f $(OUTPUT_DIR)/Process.alfredworkflow;
	(cd $^ && zip ../$(OUTPUT_DIR)/Process.alfredworkflow -r . --exclude .\*);

sync-alfred-workflow: Process.alfredworkflow
	rm -rf AlfredProcess;
	unzip -d AlfredProcess $^;

ical-alfred: target-dir cli/ical-alfred.swift
	@xcrun swiftc -sdk $(shell xcrun --show-sdk-path --sdk macosx) -o $(OUTPUT_DIR)/cli/ical-alfred cli/ical-alfred.swift
	chmod +x $(OUTPUT_DIR)/cli/ical-alfred

pb: target-dir cli/pb.swift
	@xcrun swiftc -sdk $(shell xcrun --show-sdk-path --sdk macosx) -o $(OUTPUT_DIR)/cli/pb cli/pb.swift
	chmod +x $(OUTPUT_DIR)/cli/pb

bm: target-dir cli/bm.c
	gcc -O3 -o $(OUTPUT_DIR)/cli/bm cli/bm.c
	chmod +x $(OUTPUT_DIR)/cli/bm

hotkeys: target-dir applescript hotkeys/Anykey.base.json
	./hotkeys/build.rb > $(OUTPUT_DIR)/hotkeys/Anykey.json
