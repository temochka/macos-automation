#!/usr/bin/swift
import Foundation
import Darwin
import EventKit

let store = EKEventStore()

if EKEventStore.authorizationStatus(for: .event) != .authorized {
    print("Unauthorized to access the Calendar. Will ask for permission.")
    store.requestAccess(to: .event) { _, _ in }
    exit(0)
}

let now = Date()
let eventFilter = store.predicateForEvents(withStart: now, end: now, calendars: nil)
let currentEvent = store
    .events(matching: eventFilter)
    .filter { !$0.isAllDay }
    .min(by: {
        $0.endDate.timeIntervalSince($0.startDate) < $1.endDate.timeIntervalSince($1.startDate)
    })

print(currentEvent?.eventIdentifier ?? "", terminator: "")

