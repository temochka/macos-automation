#!/usr/bin/swift
import Foundation
import Darwin
import EventKit

let store = EKEventStore()

if EKEventStore.authorizationStatus(for: .event) != .authorized {
    print("Not authorized to access the Calendar. Will ask for permission.")
    store.requestAccess(to: .event) { _, _ in }
    exit(0)
}

let now = Date()
let tomorrow = now + 3600 * 24
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .short
let eventFilter = store.predicateForEvents(withStart: now, end: tomorrow, calendars: nil)
let matchingEvents = store
    .events(matching: eventFilter)
    .filter { !$0.isAllDay }
    .prefix(5)
    .map { (event) -> NSDictionary in
        return [
            "title": event.title ?? "Untitled event",
            "subtitle": "\(dateFormatter.string(from: event.startDate))-\(dateFormatter.string(from: event.endDate))",
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
