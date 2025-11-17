-- Copies the frontmost Google Chrome tab as a Markdown link
tell application "Google Chrome"
	set theTab to active tab of front window
	set theTitle to title of theTab
	set theURL to URL of theTab
end tell

set the clipboard to "[" & theTitle & "](" & theURL & ")"
