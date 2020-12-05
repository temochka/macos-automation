tell application "Notes"
  set noteBody to "<html><body><div><h1>" & (current date as string) & "</h1><ul><li>&nbsp;</li></ul></div></body></html>"
	set newNote to make new note in default account at folder "Notes" with properties {body:noteBody}
  show newNote
end tell
