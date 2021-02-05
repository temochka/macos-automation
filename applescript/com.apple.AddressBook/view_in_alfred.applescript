property ADDRESSBOOK_DATA_DIR : "~/Library/Application\\ Support/AddressBook"

tell application "Contacts"
  set theSelection to selection
  set theId to id of item 1 of theSelection
  set theContactFile to do shell script "mdfind -onlyin " & ADDRESSBOOK_DATA_DIR & " \"kMDItemFSName='" & theId & ".abcdp' && kMDItemContentType='com.apple.addressbook.person'\""

  tell application id "com.runningwithcrayons.Alfred" to run trigger "open_file" in workflow "com.temochka.alfred.process" with argument theContactFile
end tell
