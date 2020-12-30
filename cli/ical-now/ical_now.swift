#!/usr/bin/swift
import Foundation
import Darwin
import EventKit

func isDeclined(event: EKEvent) -> Bool {
    if let attendee = event.attendees?.first(where: { $0.isCurrentUser }) {
        return attendee.participantStatus == .declined
    }
    return false
}

func tomorrowLabel(date: Date) -> String {
    let calendar = Calendar.current
    if calendar.isDateInTomorrow(date) {
        return "Tomorrow: "
    }
    return ""
}

let store = EKEventStore()

if EKEventStore.authorizationStatus(for: .event) != .authorized {
    print("Not authorized to access the Calendar. Will ask for permission.")
    let group = DispatchGroup()

    group.enter()
    store.requestAccess(to: .event) { _, _ in group.leave() }

    group.wait()
    exit(0)
}

let now = Date()
let tomorrow = now + 3600 * 24
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .short
let eventFilter = store.predicateForEvents(withStart: now, end: tomorrow, calendars: nil)
let matchingEvents = store
    .events(matching: eventFilter)
    .filter { !$0.isAllDay && $0.status != .canceled && !isDeclined(event: $0) }
    .prefix(5)
    .map { (event) -> NSDictionary in
        return [
            "title": event.title ?? "Untitled event",
            "subtitle": "\(tomorrowLabel(date: event.startDate))\(dateFormatter.string(from: event.startDate))-\(dateFormatter.string(from: event.endDate))",
            "arg": "{\"eventId\":\"\(event.eventIdentifier ?? "")\",\"calendarId\":\"\(event.calendar?.calendarIdentifier ?? "")\"}",
        ]
    }

let alfredEnvelope: NSDictionary = [
    "items": matchingEvents + [["title" : "Jump to Today", "subtitle" : "Open Today in Calendar", "arg": "{}"]]
]
let jsonData = try JSONSerialization.data(withJSONObject: alfredEnvelope)
if let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8) {
   print(jsonResult)
}
