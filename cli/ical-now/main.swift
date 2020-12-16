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
let endOfDay = Calendar.current.startOfDay(for: now + 3600*24)
let eventFilter = store.predicateForEvents(withStart: now, end: endOfDay, calendars: nil)
let currentEvent = store
    .events(matching: eventFilter)
    .filter { !$0.isAllDay }
    .min(by: {
        $0.endDate.timeIntervalSince($0.startDate) < $1.endDate.timeIntervalSince($1.startDate)
    })

print(currentEvent?.eventIdentifier ?? "", terminator: " ")
print(currentEvent?.calendar?.calendarIdentifier ?? "", terminator: "")

