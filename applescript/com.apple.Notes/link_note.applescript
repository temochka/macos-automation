on run argv
  set noteId to item 1 of argv

  tell application "Notes"
    set noteName to name of note id noteId
    set noteUrl to my getNoteUri(noteId)

    my clipTextAndHtml(noteName, "<a href=\"" & (noteUrl's shortcutsScheme) & "\">" & noteName & "</a>")
    my pasteToFrontmostApp()
  end tell

  my hookToActiveWindow(noteName, (noteUrl's hookScheme))
end run
