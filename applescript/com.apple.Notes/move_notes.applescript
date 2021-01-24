on run argv
  set folderId to item 1 of argv
	tell application "Notes"
		set theFolder to folder id folderId
		repeat with theNote in (selection as list)
			move theNote to theFolder
		end repeat
	end tell
end run
