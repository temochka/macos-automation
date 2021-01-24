tell application "Notes"
	activate
	set selectedText to my getSelectedText()
	set taskName to my reReplace("^([-* ]|\\[|\\])+", "", selectedText)
end tell

tell application "OmniFocus"
	tell front document
		set theTask to make new inbox task with properties {name:taskName}
		set theTaskUrl to "omnifocus:///task/" & (id of theTask)
	end tell
end tell

my clipTextAndHtml(taskName, "&zwnj;<a href=\"" & theTaskUrl & "\">" & taskName & "</a>&zwnj;")
my pasteToFrontmostApp()

tell application "Notes"
	set noteId to item 1 of my getSelectedNoteIds()
	set noteName to name of note id noteId
	set noteUri to (my getNoteUri(noteId))
end tell

tell application "OmniFocus"
	set theTask's note to (noteUri's shortcutsScheme)
end tell

tell application "Hook"
	set theNoteHook to make new bookmark with properties {address:(noteUri's hookScheme), name:noteName, path:""}
	set theTaskHook to make new bookmark with properties {address:theTaskUrl, name:taskName, path:""}
	hook theNoteHook and theTaskHook
end tell
