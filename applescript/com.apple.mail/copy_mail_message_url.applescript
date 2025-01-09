tell application "Mail"
	set _sel to get selection
	set _textLinks to {}
	set _htmlLinks to {}
	repeat with _msg in _sel
		set _messageURL to "message://%3c" & _msg's message id & "%3e"
		set _messageSubject to _msg's subject
		set _htmlLink to "<a href=" & _messageURL & "\">" & _messageSubject & "</a>"
		set end of _textLinks to _messageURL
		set end of _htmlLinks to _htmlLink
	end repeat
	set AppleScript's text item delimiters to return
	my clipTextAndHtml(_textLinks as string, _htmlLinks as string)
end tell
