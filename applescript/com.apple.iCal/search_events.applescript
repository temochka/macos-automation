on run argv
  if argv's length is 0 then
    set theQuery to ""
  else
    set theQuery to item 1 of argv
  end if

  do shell script "~/bin/ical-alfred search " & (quoted form of theQuery)
end run
