on run argv
  set contactId to item 1 of argv

  tell application "Contacts"
    set contactName to first name of person id contactId
    set contactUrl to "addressbook://" & contactId

    my clipTextAndHtml(contactName, "<a href=\"" & contactUrl & "\">" & contactName & "</a>")
    my pasteToFrontmostApp()
  end tell

  my hookToActiveWindow(contactName, contactUrl)
end run
