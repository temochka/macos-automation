var Safari = Application('Safari');
Safari.includeStandardAdditions = true;

var OmniFocus = Application('OmniFocus');

var currentWindow = Safari.windows[0];
var currentTab = currentWindow.currentTab();
var url = currentTab.url();

var matches = url.match(/\/([^\/]+)\/([^\/]+)\/(pull|issues)\/(\d+)/);

if (matches) {
  var link = `${matches[1]}/${matches[2]}#${matches[4]}`
  Safari.setTheClipboardTo(link);
}
