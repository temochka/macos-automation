function run(argv) {
    var Safari = Application('Safari');
    var query = "1:2"
    let [windowIndex, tabIndex] = query.split(":");

    Safari.windows[windowIndex].actions["AXRaise"].perform();
    Safari.windows[windowIndex].currentTab = tabIndex;
}
