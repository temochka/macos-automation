property DAILY_NOTES_FOLDER : "🗓 Daily Notes"

tell application "Notes"
	set currentDate to do shell script "date +%F"
	set noteTitle to currentDate & " - Daily Note"
	try
		set theNoteId to id of first note in folder DAILY_NOTES_FOLDER whose name = noteTitle
	on error
		set noteBody to "<h1>" & noteTitle & "</h1>"
		set theNoteId to id of (make new note in folder DAILY_NOTES_FOLDER in default account with properties {body:noteBody})
	end try
	show note id theNoteId
end tell
