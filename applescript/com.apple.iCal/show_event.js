function run(argv) {
	var input = JSON.parse(argv);
	var {eventId, calendarId} = input;
	var Calendar = Application("Calendar");
	Calendar.switchView({to: "day view"});
	Calendar.viewCalendar({at: new Date()});

	if (eventId) {
		var event = Calendar.calendars.byId(calendarId).events.byId(eventId);
		Calendar.show(event);
	}
}
