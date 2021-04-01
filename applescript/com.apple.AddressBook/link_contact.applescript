on run argv
  set contactId to item 1 of argv

  if contactId is not "" then
    tell application "Contacts"
      set contactName to first name of person id contactId
      set contactUrl to "addressbook://" & contactId

      my clipTextAndHtml(contactName, "<a href=\"" & contactUrl & "\">" & contactName & "</a>")
      my pasteToFrontmostApp()
    end tell

    my hookToActiveWindow(contactName, contactUrl)
  else
    tell application "Contacts"
      set nameList to words of (system attribute "create_contact")
      set firstName to item 1 of nameList
      if (nameList's length) > 1 then
        set lastName to item 2 of nameList
      end if
      set theContact to make new person with properties {first name: firstName, last name: lastName}
      save addressbook
      activate
      set selection to theContact
    end tell
  end if
end run
