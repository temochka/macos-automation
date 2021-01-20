tell application "Mail"
	set _sel to get selection
	set _links to {}
	repeat with _msg in _sel
		set _messageURL to "message://%3c" & _msg's message id & "%3e"
		set end of _links to _messageURL
	end repeat
	set AppleScript's text item delimiters to return
	set the clipboard to (_links as string)
end tell
