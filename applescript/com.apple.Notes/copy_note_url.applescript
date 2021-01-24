tell application "Notes"
	set noteId to item 1 of (my getSelectedNoteIds())
	set uriRow to (my getNoteUri(noteId))'s shortcutsScheme
	set noteName to name of note id noteId in default account
	if noteName is not equal to "" then
		set titleRow to "“" & noteName & "”"
	else
		set titleRow to ""
	end if
	set textLink to titleRow & "\n\n" & uriRow
	set htmlLink to titleRow & "<br>" & "<a href=\"" & uriRow & "\">" & uriRow & "</a>"

	my clipTextAndHtml(textLink, htmlLink)
end tell
