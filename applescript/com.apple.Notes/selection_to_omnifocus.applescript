tell application "Notes"
	activate
	set currentSelection to my getSelection()
	set taskName to my reReplace("^([-* ]|\\[|\\])+", "", currentSelection's |text|)
	set taskNote to currentSelection's |url|
end tell

tell application "OmniFocus"
	tell front document
		set theTask to make new inbox task with properties {name:taskName}
		set theTaskUrl to "omnifocus:///task/" & (id of theTask)
	end tell
end tell

my clipTextAndHtml(taskName, "<a href=\"" & theTaskUrl & "\">" & taskName & "</a>")
my pasteToFrontmostApp()

tell application "Notes"
	set noteId to item 1 of my getSelectedNoteIds()
	set noteName to name of note id noteId
	set noteUri to (my getNoteUri(noteId))
end tell

tell application "OmniFocus"
	set theTask's note to taskNote & "\n\n" & (noteUri's shortcutsScheme)
end tell

tell application "Hook"
	set theNoteHook to make new bookmark with properties {address:(noteUri's hookScheme), name:noteName, path:""}
	set theTaskHook to make new bookmark with properties {address:theTaskUrl, name:taskName, path:""}
	hook theNoteHook and theTaskHook
end tell
