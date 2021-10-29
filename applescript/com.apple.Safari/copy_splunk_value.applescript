tell application "Safari"
	tell window 1
		tell current tab
			do JavaScript "navigator.clipboard.writeText($('.selected-segment').text())"
		end tell
	end tell
end tell
