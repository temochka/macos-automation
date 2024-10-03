# macOS automation scripts

A collection of my macOS automation scripts (Alfred workflow, AppleScript and JXA). To compile, run:

``` bash
make all
```

## AlfredProcess

A mega-workflow for [Alfred](https://www.alfredapp.com) that encompasses all of my custom automations. See its own [README](AlfredProcess/README.md) for details. To build just the workflow, run:

``` bash
make alfred-workflow
```

Then install the workflow via:

``` bash
open target/Process.alfredworkflow
```

<!-- End AlfredProcess -->

## Hotkeys

I use an app I built called [Anykey](https://github.com/temochka/Anykey) to assign hotkeys to some of the automations. The Anykey configuration file is automatically built from individual launchers.

<!-- End Hotkeys -->

<img src="AlfredProcess/assets/icons/calendar-alt.png" width="75" alt="Calendar Icon" title="Calendar" align="right" style="background-color: #fff;">

## Calendar

### Jump to upcoming event

Type `nowc` into Alfred to get a list of current and upcoming events on your calendar and quickly open them in Calendar app.

<img src="assets/screenshots/nowc.png" alt="Jump to event screenshot" width="600">

### Jump to relevant link

Type `nowl` into Alfred to get a list of links mentioned in current and upcoming events’ descriptions. Useful for quickly joining Zoom calls.

<img src="assets/screenshots/nowl.png" alt="Jump to event screenshot" width="600">

### Link to event

Insert a link to an event via Alfred search.

<!-- End Calendar -->

## Contacts

### Open in Alfred

Contacts app is awkward to navigate with the keyboard so this is convenient for quickly copying fields to clipboard.

### Link to Contact

Insert a link to another contact via Alfred search.

<!-- End Contacts -->

## Finder

### Add/edit tags

Trigger the "Add/Edit tags" toolbar action for the selected file(s). The only way to assign a keyboard shortcut to this action, AFAIK.

<!-- End Finder -->

## Mail

### Copy Mail message URL

Copies local URLs to messages in Apple Mail for quick referencing. URLs look like below and work both on macOS and iOS:

```
message://%3c20200219T233150.531069615694520168.noreply@letsencrypt.org%3e
```

<img src="AlfredProcess/assets/icons/sticky-note.png" width="75" alt="Sticky Note Icon" title="Notes icon" align="right" style="background-color: #fff;">

<!-- End Mail -->

## Safari

### Open Highlighted Link

Safari doesn’t automatically focus elements highlighted via search by page (like Chrome or Firefox). However, it can be done with a bit of AppleScript. [Read more](https://temochka.com/blog/posts/2018/12/18/navigating-the-web-safari.html) on my blog.

### Copy GitHub issue/PR link

GitHub allows linking to issues and PRs using the following short format: owner/repo#issue. I’m not aware of an easy way to quickly produce a link in this format. This script closes this gap for me.

<!-- End Safari -->
