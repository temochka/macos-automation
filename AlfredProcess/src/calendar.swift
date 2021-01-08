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

func urlName(url: URL) -> String {
    switch url.scheme! {
        case "https", "http":
            switch url.host! {
            case let host where host == "docs.google.com":
                return "Google Docs"
            case let host where host == "zoom.us" || host.hasSuffix(".zoom.us"):
                return "Zoom"
            default:
                return url.host!
            }
        case "omnifocus":
            return "OmniFocus"
        default:
            return url.scheme!
    }
}

func getEvents(store: EKEventStore) -> NSDictionary {
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

    return alfredEnvelope
}

func getLinks(store: EKEventStore) -> NSDictionary {
    let now = Date()
    let endOfDay = Calendar.current.startOfDay(for: now + 3600*24)
    let eventFilter = store.predicateForEvents(withStart: now, end: endOfDay, calendars: nil)
    let currentEvent = store
        .events(matching: eventFilter)
        .filter { !$0.isAllDay && $0.status != .canceled && !isDeclined(event: $0) }
        .min(by: {
            abs($0.startDate.timeIntervalSince(now)) < abs($1.startDate.timeIntervalSince(now))
        })
        
    if let currentEvent = currentEvent {
        let allTextFields = "\(currentEvent.title ?? "")\n\(currentEvent.notes ?? "")\n\(currentEvent.location ?? "")\n\(currentEvent.url?.absoluteString ?? "")"
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let alfredItems = detector
            .matches(in: allTextFields, options: [], range: NSMakeRange(0, allTextFields.count))
            .compactMap { (match) -> NSDictionary? in
                if let url = match.url {
                    return [
                        "title": "\(currentEvent.title ?? "N/A") - \(urlName(url: url))",
                        "subtitle": url.absoluteString,
                        "arg": url.absoluteString,
                    ]
                }
                return nil
            }
            
        let alfredEnvelope: NSDictionary = [
            "items": alfredItems
        ]

        return alfredEnvelope
    }

    return [:]
}

func toJSON(dict: NSDictionary) -> String {
    let jsonData = try! JSONSerialization.data(withJSONObject: dict)
    if let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8) {
        return jsonResult
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
    if EKEventStore.authorizationStatus(for: .event) != .authorized {
        exit(1)
    }
}

switch CommandLine.arguments[1] {
case "events":
    print(toJSON(dict: getEvents(store: store)))
case "links":
    print(toJSON(dict: getLinks(store: store)))
default:
    print("Unknown command. Known commands are: links, events.")
}
