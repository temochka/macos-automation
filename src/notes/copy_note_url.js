var SystemEvents = Application('System Events');
var NotesApp = Application('Notes');
var NotesProcess = SystemEvents.processes['Notes'];
var NotesWindow = NotesProcess.windows[0];

NotesApp.includeStandardAdditions = true;

function selectedFolderName() {
    const foldersList = NotesWindow
        .splitterGroups[0]
        .scrollAreas[0]
        .outlines[0]
		.rows;
    const selectedFolder = foldersList.whose({ selected: true })[0];
    return selectedFolder.uiElements[0].uiElements[0].name() || selectedFolder.uiElements[0].textFields[0].value();
}

function selectedNoteName() {
    const notesList = NotesWindow
		.splitterGroups[0]
		.splitterGroups[0]
		.groups[0]
		.scrollAreas[0]
		.tables[0]
		.rows;
    const selectedRow = notesList.whose({ selected: true })[0];
    return selectedRow.uiElements[0].staticTexts[0].value();
}

function run() {
	NotesApp.activate();

	const searchFolder = NotesApp.folders.whose({name: selectedFolderName()})()[0] || NotesApp;
	const selectedNote = searchFolder
	  	.notes
    	.byName(selectedNoteName());
	const timestamp =
		Math.floor(selectedNote.creationDate().getTime() / 1000);
		
	const name = selectedNote.name().length ? `“${selectedNote.name()}”\n\n` : ""
	const url = `shortcuts://run-shortcut?name=NoteURL&input=${encodeURIComponent(timestamp)}`;

	NotesApp.setTheClipboardTo(`${name}${url}`);
}
