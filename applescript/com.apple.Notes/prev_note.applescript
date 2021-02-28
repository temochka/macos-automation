tell application "Notes"
	set noteId to id of (item 1 of (selection as list))
	set theNote to note id noteId in default account
	set theFolder to theNote's container
	set totalNotes to count of theFolder's notes
	repeat with i from 1 to totalNotes
		if id of item i of theFolder's notes = noteId then
			set prevOffset to i - 1
			exit repeat
		end if
	end repeat

	if prevOffset is not missing value and prevOffset >= 1 then
		show item prevOffset of theFolder's notes
	end if
end tell
