use framework "Foundation"
use scripting additions

property NSDate : a reference to current application's NSDate
property NSNumber : a reference to current application's NSNumber
property NSPasteboard : a reference to current application's NSPasteboard
property NSPasteboardTypeHTML : a reference to current application's NSPasteboardTypeHTML
property NSPasteboardTypeString : a reference to current application's NSPasteboardTypeString
property NSString : a reference to current application's NSString
property NSUTF16StringEncoding : a reference to current application's NSUTF16StringEncoding
property NOTE_SHORTCUTS_URL_PREFIX : "shortcuts://run-shortcut?name=NoteURL&input="
property NOTE_HOOK_URL_PREFIX : "hook://notes/dt/"

on clipTextAndHtml(theText, theHtml)
  set htmlBody to theHtml
	set nsStringHtmlBody to NSString's stringWithString:(htmlBody & "&zwnj;")
	set htmlBodyData to nsStringHtmlBody's dataUsingEncoding:NSUTF16StringEncoding
	set pb to NSPasteboard's generalPasteboard()
	pb's clearContents()
	pb's setString:theText forType:NSPasteboardTypeString
  pb's setData:htmlBodyData forType:NSPasteboardTypeHTML
end clipTextAndHtml

on getSelectedNoteIds()
  tell application "Notes"
    set ids to {}
    repeat with theNote in (selection as list)
      set ids to ids & {«class seld» of (theNote as record)}
    end repeat
    return ids
  end tell
end getSelectedNoteIds

on getNoteUri(noteId)
  tell application "Notes"
    set noteCreated to (creation date) of note id noteId in default account
    set cocoaDate to NSDate's dateWithTimeInterval:0 sinceDate:noteCreated
    set doubleNoteTimestamp to cocoaDate's timeIntervalSince1970
    set intNoteTimestamp to intValue of (NSNumber's numberWithDouble:doubleNoteTimestamp)
    set stringNoteTimestamp to stringValue of (NSNumber's numberWithInt:intNoteTimestamp)
    set shortcutsUri to (my NOTE_SHORTCUTS_URL_PREFIX) & stringNoteTimestamp
    set hookUri to (my NOTE_HOOK_URL_PREFIX) & stringNoteTimestamp
    return {shortcutsScheme: shortcutsUri, hookScheme: hookUri}
  end tell
end getNoteUri

-- Cheers to user3439894 for this beautiful hack
-- https://apple.stackexchange.com/questions/417833/how-to-convert-applescript-url-type-to-string#417835
on urlToString(theURL)
  set tmpfile to (do shell script "mktemp")
  set fhandle to open for access tmpfile with write permission
  write theURL to fhandle
  close access fhandle
  read tmpfile
end urlToString

on getClipboardUrl()
  try
    my urlToString(the clipboard as URL)
  on error errMsg number n
    if n = -1700 then -- No URL in the clipboard
      return missing value
    end if
  end try
end getClipboardUrl

on getSelection()
  tell application "System Events" to keystroke "c" using {command down}
  delay 0.1
  return {|text|: (the clipboard as string), |url|: getClipboardUrl()}
end getSelection

on reReplace(regexp, replacement, str)
	set pattern to "s/" & regexp & "/" & replacement & "/g"
	set sed to "sed -E " & quoted form of pattern
	do shell script "echo " & (quoted form of str) & " | " & sed
end reReplace

on pasteToFrontmostApp()
  tell application "System Events" to keystroke "v" using {command down}
  delay 0.1
end pasteToFrontmostApp

on hookToActiveWindow(bookmarkName, bookmarkUrl)
  tell application "Hookmark"
    set targetBookmark to bookmark from active window
    set sourceBookmark to make new bookmark with properties {address:bookmarkUrl, name:bookmarkName, path:""}

    hook sourceBookmark and targetBookmark
  end tell
end hookToActiveWindow
