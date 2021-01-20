var Safari = Application('Safari');
var OmniFocus = Application('OmniFocus');

var currentWindow = Safari.windows[0];
var currentTab = currentWindow.currentTab();
var task = OmniFocus.InboxTask({ name: currentTab.name(), note: currentTab.url() });

OmniFocus.quickEntry.open();
OmniFocus.quickEntry.inboxTasks.push(task);
