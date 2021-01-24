property DAILY_NOTES_FOLDER : "🗓 Daily Notes"

tell application "Notes"
	set currentDate to do shell script "date +%F"
	set noteTitle to currentDate & " - Daily Note"
	try
		set theNote to first note in folder DAILY_NOTES_FOLDER whose name = noteTitle
	on error
		set noteBody to "<html><body><div><h1>" & noteTitle & "</h1><ul><li>&nbsp;</li></ul></div></body></html>"
		set theNote to make new note in folder DAILY_NOTES_FOLDER in default account with properties {body:noteBody}
	end try
	show theNote
end tell
