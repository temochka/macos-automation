on open location noteURL
	tell application "Notes"
		if (offset of (my NOTE_URL_PREFIX) in noteURL) is 0 then
			display dialog ("Don't know how to handle the following URL: " & noteURL) buttons { "OK" }
			return
		end if

		set timestampArg to characters 45 thru -1 of noteURL as text
		set stringTimestamp to (NSString's stringWithString:timestampArg)
		set doubleTimestamp to stringTimestamp's doubleValue
		set creationDate to (NSDate's dateWithTimeIntervalSince1970:doubleTimestamp) as date
		set theNoteId to id of first note in default account whose creation date ³ creationDate and creation date < (creationDate + 1)
		show note id theNoteId
	end tell
end open location

on run
	display dialog ("The script will now try to read your notes! You might be prompted for permissions.") buttons { "OK", "Cancel" } default button "OK" cancel button "Cancel"
	tell application "Notes"
		set theNoteId to id of first note in default account
		display dialog ("You should be all set!") buttons { "OK" }
	end tell
end run
