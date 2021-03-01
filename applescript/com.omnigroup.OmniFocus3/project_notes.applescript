-- Inspired by https://github.com/dbyler/omnifocus-scripts/blob/master/Append%20Note%20to%20Selected%20Task.applescript

tell application "OmniFocus"
  tell content of first document window of front document
    set validSelectedItemsList to value of (selected trees where class of its value is not item and class of its value is not folder and class of its value is not tag and class of its value is not perspective)
    set totalItems to count of validSelectedItemsList
    if totalItems is 0 then
      display notification "No tasks or projects selected" with title "Error"
      return
    end if

    if totalItems > 1 then
      display notification "Multiple items selected." with title "Error"
      return
    end if

    repeat with myTask in validSelectedItemsList
      if myTask's class is task then
        set theProject to myTask's containing project
      else
        set theProject to myTask
      end if

      set noteURLs to (every paragraph of theProject's note where it starts with (my NOTE_SHORTCUTS_URL_PREFIX))

      if (count of noteURLs) is 0 then
        tell application "Notes"
          set taskUrl to "omnifocus:///task/" & (theProject's id)
          set noteBody to "<h1>" & theProject's name & "</h1><p><a href=" & taskUrl & ">" & taskUrl & "</a></p><ul><li></li></ul>"
          set newNote to make new note in default account at folder "Notes" with properties {body: noteBody}
          set noteId to «class seld» of (newNote as record)
          set noteURL to shortcutsScheme of (my getNoteUri(noteId))
        end tell
        tell theProject
          insert noteURL & "

" at before first paragraph of note
        end tell
      else
        set noteURL to first item in noteURLs
      end if

      tell application "System Events"
        open location noteURL
      end tell
    end repeat
  end tell
end tell
