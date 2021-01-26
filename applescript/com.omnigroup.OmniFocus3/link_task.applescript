on run argv
  set taskId to item 1 of argv

  tell application "Hook"
    set activeBookmark to bookmark from active window
  end tell

  tell application "OmniFocus"
    tell default document
      set taskName to name of flattened task id taskId
      set taskUrl to "omnifocus:///task/" & taskId

      my clipTextAndHtml("", "<a href=\"" & taskUrl & "\">" & taskName & "</a>")
      my pasteToFrontmostApp()
    end tell
  end tell

  tell application "Hook"
    set taskBookmark to make new bookmark with properties {address:taskUrl, name:taskName, path:""}
    hook activeBookmark and taskBookmark
  end tell
end run
