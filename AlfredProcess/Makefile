all: calendar

clean:
	rm -rf assets/calendar

calendar: src/calendar.swift
	@xcrun swiftc -sdk $(shell xcrun --show-sdk-path --sdk macosx) -o assets/calendar $^;
	chmod +x assets/calendar
