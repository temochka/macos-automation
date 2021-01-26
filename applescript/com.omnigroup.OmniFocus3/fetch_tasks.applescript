on filteredTasks(query)
  tell application "OmniFocus"
    repeat with i from 0 to 4
      try
        set matches to {ids:id, names:name} of (flattened tasks 1 thru (5 - i) in default document whose completed is false and dropped is false and name contains query)
        return matches
      on error errMsg number n
        if n is not -1719 and n is not -1728 then
          error errMsg number n
        end if
      end try
    end repeat
  end tell
  return {ids:{}, names:{}}
end filteredTasks

on allTasks()
  tell application "OmniFocus"
    repeat with i from 0 to 4
      try
        set matches to {ids:id, names:name} of (flattened tasks 1 thru (5 - i) in default document whose completed is false and dropped is false)
        return matches
      on error errMsg number n
        if n is not -1719 and n is not -1728 then
          error errMsg number n
        end if
      end try
    end repeat
  end tell
  return {ids:{}, names:{}}
end allTasks

on run argv
  if count of argv > 0 then
    set query to item 1 of argv
  else
    set query to ""
  end if

  tell application "OmniFocus"
    if query is not "" then
      set matchingRecords to (my filteredTasks(query))
    else
      set matchingRecords to (my allTasks())
    end if

    set alfredItems to {}

    repeat with i from 1 to count matchingRecords's ids
      set end of alfredItems to {title:item i of matchingRecords's names, arg:item i of matchingRecords's ids}
    end repeat

    tell application "JSON Helper"
      return make JSON from {|items|:alfredItems}
    end tell
  end tell
end run
