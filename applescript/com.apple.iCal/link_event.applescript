on run argv
  set theInputJson to item 1 of argv

  tell application "JSON Helper"
    set eventInfo to read JSON from theInputJson
  end tell

  -- hook://ical/eventID=0C569011-DE79-4B10-95A5-748D6F807B99calendarID=52F82A31-E7AD-414A-8A1F-C5560B33EEEB
  set eventUrl to "hook://ical/eventID=" & eventInfo's eventId & "calendarID=" & eventInfo's calendarId

  my clipTextAndHtml(eventInfo's title, "<a href=\"" & eventUrl & "\">" & eventInfo's title & "</a>")
  my pasteToFrontmostApp()

  my hookToActiveWindow(eventInfo's title, eventUrl)
end run
