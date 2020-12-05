tell application "Safari"
	tell window 1
		tell current tab
			do JavaScript "window.getSelection().anchorNode.parentElement.closest('a,button').click()"
		end tell
	end tell
end tell
