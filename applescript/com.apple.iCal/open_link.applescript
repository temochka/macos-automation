on run argv
  if argv's length is 0 then
    tell application "Calendar"
      switch view to day view
      view calendar at current date
    end tell
  else
    set theUrl to item 1 of argv
    open location theUrl
  end if
end run
