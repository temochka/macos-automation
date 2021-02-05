on filteredContacts(query)
  tell application "Contacts"
    repeat with i from 0 to 4
      try
        set matches to {ids:id, names:name} of (people 1 thru (5 - i) whose last name contains query or first name contains query)
        return matches
      on error errMsg number n
        if n is not -1719 and n is not -1728 then
          error errMsg number n
        end if
      end try
    end repeat
  end tell
  return {ids:{}, names:{}}
end filteredContacts

on allContacts()
  tell application "Contacts"
    repeat with i from 0 to 4
      try
        set matches to {ids:id, names:name} of people 1 thru (5 - i)
        return matches
      on error errMsg number n
        if n is not -1719 and n is not -1728 then
          error errMsg number n
        end if
      end try
    end repeat
  end tell
  return {ids:{}, names:{}}
end allContacts

on run argv
  if count of argv > 0 then
    set query to item 1 of argv
  else
    set query to ""
  end if

  tell application "Contacts"
    if query is not "" then
      set matchingRecords to (my filteredContacts(query))
    else
      set matchingRecords to (my allContacts())
    end if

    set alfredItems to {}

    repeat with i from 1 to count matchingRecords's ids
      set end of alfredItems to {|title|:item i of matchingRecords's names, arg:item i of matchingRecords's ids}
    end repeat

    tell application "JSON Helper"
      return make JSON from {|items|:alfredItems}
    end tell
  end tell
end run
