on run argv
  if argv's length is 0 then
    tell application "Notes"
      activate
    end tell
  else
    set theUrl to item 1 of argv
    open location theUrl
  end if
end run
