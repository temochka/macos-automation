tell application "OmniFocus"
  tell content of first document window of front document
    set validSelectedItemsList to value of (selected trees where class of its value is not item and class of its value is not folder and class of its value is not tag and class of its value is not perspective)
    set totalItems to count of validSelectedItemsList

    if totalItems is not 1 then
      display notification "Please select one task or project to time-block" with title "Error"
      return
    end if

    repeat with myTask in validSelectedItemsList
      tell application "Calendar"
        set taskUrl to "omnifocus:///task/" & (myTask's uid)
        set theEvent to make new event in calendar "Time Blocks" with properties {summary:myTask's name, start date:current date, end date:(current date) + (1 * hours), url:taskUrl}
        show theEvent
      end tell
    end repeat
  end tell
end tell
