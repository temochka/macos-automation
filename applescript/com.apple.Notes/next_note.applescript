tell application "Notes"
	set noteId to id of (item 1 of (selection as list))
	set theNote to note id noteId in default account
	set theFolder to theNote's container
	set totalNotes to count of theFolder's notes
	repeat with i from 1 to totalNotes
		if id of item i of theFolder's notes = noteId then
			set nextOffset to i + 1
			exit repeat
		end if
	end repeat

	if nextOffset is not missing value and nextOffset ≤ totalNotes then
		show item nextOffset of theFolder's notes
	end if
end tell
