use framework "Foundation"
use scripting additions

property NSMutableAttributedString : a reference to current application's NSMutableAttributedString
property NSNull : a reference to current application's NSNull
property NSDate : a reference to current application's NSDate
property NSNumber : a reference to current application's NSNumber
property NSPasteboardTypeRTF : a reference to current application's NSPasteboardTypeRTF
property NSPasteboardTypeString : a reference to current application's NSPasteboardTypeString
property NSRTFTextDocumentType : a reference to current application's NSRTFTextDocumentType
property NSString : a reference to current application's NSString
property NSUTF8StringEncoding : a reference to current application's NSUTF8StringEncoding
property NOTE_SHORTCUTS_URL_PREFIX : "shortcuts://run-shortcut?name=NoteURL&input="
property NOTE_HOOK_URL_PREFIX : "hook://notes/dt/"

on clipTextAndHtml(theText, theHtml)
  set htmlBody to ("<html><head><meta charset=\"UTF-8\" /></head><body>" & theHtml & "</body></html>")
	set nsStringHtmlBody to NSString's stringWithString:htmlBody
	set htmlBodyData to nsStringHtmlBody's dataUsingEncoding:NSUTF8StringEncoding
	set attributedString to NSMutableAttributedString's alloc()
	attributedString's initWithHTML:htmlBodyData documentAttributes:NSNull
	set range to {0, attributedString's |length|}
	set theRtf to (attributedString's RTFFromRange:range documentAttributes:{DocumentType:NSRTFTextDocumentType})
	set pb to current application's NSPasteboard's generalPasteboard()
	pb's clearContents()
	pb's setData:theRtf forType:NSPasteboardTypeRTF
	pb's setString:theText forType:NSPasteboardTypeString
end clipTextAndHtml

on getSelectedNoteIds()
  tell application "Notes"
    set ids to {}
    repeat with theNote in (selection as list)
      set ids to ids & {theNote's id}
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

on getSelectedText()
  set clipboardBefore to the clipboard
  tell application "System Events" to keystroke "c" using {command down}
  delay 0.1
  set selectedText to (the clipboard as string)
  set the clipboard to clipboardBefore
  return selectedText
end getSelectedText

on reReplace(regexp, replacement, str)
	set pattern to "s/" & regexp & "/" & replacement & "/gi"
	set sed to "sed -E " & quoted form of pattern
	do shell script "echo " & (quoted form of str) & " | " & sed
end reReplace

on pasteToFrontmostApp()
	delay 0.1
	tell application "System Events" to keystroke space
	tell application "System Events" to key code 123 -- left	
	tell application "System Events" to keystroke "v" using {command down}
	delay 0.1
	tell application "System Events" to key code 124 -- right
	tell application "System Events" to key code 51 -- delete
end pasteToFrontmostApp
