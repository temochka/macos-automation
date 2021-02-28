tell application "Notes"
	set noteId to id of (item 1 of (selection as list))
	set theNote to note id noteId in default account
	set theFolder to theNote's container
	set totalNotes to count of theFolder's notes
	set allNoteIds to ids of {ids:id} of notes 1 thru totalNotes of theFolder
	repeat with i from 1 to totalNotes
		if item i of allNoteIds = noteId then
			set nextOffset to i + 1
			exit repeat
		end if
	end repeat

	if nextOffset is not missing value and nextOffset ≤ totalNotes then
		show item nextOffset of theFolder's notes
	end if
end tell
