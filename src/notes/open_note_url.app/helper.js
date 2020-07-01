var NotesApp = Application('Notes');

function run(input) {
	const url = `${input}`;
	const noteCreationTimestamp = parseInt(url.replace(/^shortcuts:\/\/run\-shortcut\?name=NoteURL&input=/, ""));
	const dateLowerBound = new Date(noteCreationTimestamp * 1000);
	const dateUpperBound = new Date((noteCreationTimestamp + 1) * 1000);
	const note = NotesApp
		.notes
		.whose({
			_and: [
				{ creationDate: { _greaterThanEquals: dateLowerBound } },
				{ creationDate: { _lessThan: dateUpperBound } }
			]
		})
		.at(0);
	note.show();
}
