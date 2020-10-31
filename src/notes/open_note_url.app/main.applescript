use framework "Foundation"
use scripting additions
property NSDate : a reference to current application's NSDate
property NSString : a reference to current application's NSString
property NSNumber : a reference to current application's NSNumber

on open location noteURL
	tell application "Notes"
		-- a supported noteURL looks like: shortcuts://run-shortcut?name=NoteURL&input=1604094720
		set prefix to "shortcuts://run-shortcut?name=NoteURL&input="

		if (offset of prefix in noteURL) is 0 then
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
