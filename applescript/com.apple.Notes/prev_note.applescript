tell application "Notes"
	set noteId to item 1 of my getSelectedNoteIds()
	set theNote to note id noteId in default account
	set theFolder to theNote's container
	set totalNotes to count of theFolder's notes
	set allNoteIds to ids of {ids:id} of notes 1 thru totalNotes of theFolder
	repeat with i from 1 to totalNotes
		if item i of allNoteIds = noteId then
			set prevOffset to i - 1
			exit repeat
		end if
	end repeat

	if prevOffset is not missing value and prevOffset >= 1 then
		show item prevOffset of theFolder's notes
	end if
end tell
