function run(argv) {
  var query = argv[0];
  var app = Application('Notes');
  var folders = query ? app.folders.whose({ name: { _contains: query } }) : app.folders;
  return JSON.stringify({
    items: folders().slice(0, 5).map(folder =>
      ({ title: folder.name()
      , subtitle: `Move to ${folder.name()}`
      , arg: folder.id()
      })
    )
  })
}
