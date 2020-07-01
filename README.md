# macOS automation scripts

A collection of my macOS automation scripts (Alfred workflows, AppleScript and JXA). To compile, run:

``` bash
make all
```

## Alfred

### GitHub Bookmarks

An Alfred workflow to quickly jump to any of your GitHub repositories, private or public. Requires `jq` (`brew install jq`) and a GitHub account.

## Mail

### Copy Mail message URL

Copies local URLs to messages in Apple Mail for quick referencing. URLs look like below and work both on macOS and iOS:

```
message://%3c20200219T233150.531069615694520168.noreply@letsencrypt.org%3e
```

## Notes

### Open Note URL / Copy Note URL

Apple Notes doesn’t provide URLs that work reliably across devices. I link to my notes using the following URLs format

```
shortcuts://run-shortcut?name=NoteURL&input=1582228319
```

This format works both on macOS (via these scripts) and iOS (via custom shortcuts) and relies on note creation date, which is
extremely reliable and unlikely to change.

### Generate Vocabulary Update

Whenever I see an unknown English word, I add it to a note in "🇬🇧English" folder. This script combine these separate notes into a single list that I can load into my space repetition software.

## Safari

## Open Highlighted Link

Safari doesn’t automatically focus elements highlighted via search by page (like Chrome or Firefox). However, it can be done with a bit of AppleScript. [Read more](https://temochka.com/blog/posts/2018/12/18/navigating-the-web-safari.html) on my blog.

## Safari tab to OmniFocus

I could never figure out how to quickly add a Safari web page to OmniFocus (so it puts the page title into task and URL as a note) so I wrote this shortcut. Works for me!
