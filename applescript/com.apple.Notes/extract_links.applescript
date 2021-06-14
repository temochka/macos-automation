set NSDataDetector to current application's NSDataDetector
set NSError to current application's NSError
set NSTextCheckingTypeLink to current application's NSTextCheckingTypeLink

tell application "Notes"
  set ids to {}
  repeat with theNote in (selection as list)
    set ids to ids & {theNote's id}
  end repeat
  set theNote to note id (item 1 of ids)
  set theHtmlBody to theNote's body
  set theTextBody to (do shell script "echo " & (quoted form of theHtmlBody) & " | textutil -stdin -stdout -format html -convert txt")

  set theBodyNsString to NSString's stringWithString:theTextBody
  set theError to NSError's alloc()
  set dataDetector to NSDataDetector's dataDetectorWithTypes:NSTextCheckingTypeLink |error|:theError
  set matches to dataDetector's matchesInString:theBodyNsString options:0 range:{0, theTextBody's length}

  set links to {}

  repeat with theMatch in matches
    set theLink to (theBodyNsString's substringWithRange:(theMatch's range)) as text
    set end of links to {title: theLink, arg: theLink}
  end repeat

  tell application "JSON Helper"
    return make JSON from {|items|:links}
  end tell
end tell
