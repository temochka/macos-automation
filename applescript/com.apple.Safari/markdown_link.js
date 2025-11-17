var Safari = Application('Safari');
Safari.includeStandardAdditions = true;

var currentWindow = Safari.windows[0];
var currentTab = currentWindow.currentTab();

var link = `[${currentTab.name()}](${currentTab.url()})`;
Safari.setTheClipboardTo(link);
