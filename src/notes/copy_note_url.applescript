use framework "Foundation"
use scripting additions
property NSDate : a reference to current application's NSDate
property NSNumber : a reference to current application's NSNumber

tell application "Notes"
	set selectedNote to (get selection as record)
	set noteId to «class seld» of selectedNote
	set noteName to name of note id noteId in default account
	set noteCreated to (creation date) of note id noteId in default account
	set cocoaDate to NSDate's dateWithTimeInterval:0 sinceDate:noteCreated
	set doubleNoteTimestamp to cocoaDate's timeIntervalSince1970
	set intNoteTimestamp to intValue of (NSNumber's numberWithDouble:doubleNoteTimestamp)
	set stringNoteTimestamp to stringValue of (NSNumber's numberWithInt:intNoteTimestamp)
	if noteName is not equal to "" then
		set titleRow to "“" & noteName & "”\n\n"
	else
		set titleRow to ""
	end if
	set uriRow to "shortcuts://run-shortcut?name=NoteURL&input=" & stringNoteTimestamp
	set the clipboard to titleRow & uriRow
end tell
