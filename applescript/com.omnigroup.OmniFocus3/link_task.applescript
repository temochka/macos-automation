on run argv
  set taskId to item 1 of argv

  tell application "OmniFocus"
    tell default document
      set taskName to name of flattened task id taskId
      set taskUrl to "omnifocus:///task/" & taskId

      my clipTextAndHtml(taskName, "<a href=\"" & taskUrl & "\">" & taskName & "</a>")
      my pasteToFrontmostApp()
    end tell
  end tell

  my hookToActiveWindow(taskName, taskUrl)
end run
