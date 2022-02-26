function run(argv) {
  var Safari = Application('Safari');
  let items = [];

  for (const window of Safari.windows()) {
  	if (window.tabs() === null) continue;

  	for (const tab of window().tabs()) {
      items.push({
        title: tab.name(),
        subtitle: tab.url(),
        arg: `${window.index()}:${tab.index()}`,
      })
	}
  }

  return items;
}
