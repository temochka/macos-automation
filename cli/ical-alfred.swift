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

func getEvents(store: EKEventStore, until: Date, query: String?, calendars: [EKCalendar]) -> NSDictionary {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    let eventFilter = store.predicateForEvents(withStart: now, end: until, calendars: calendars)
    let matchingEvents = store
        .events(matching: eventFilter)
        .filter {
            !$0.isAllDay &&
                $0.status != .canceled &&
                !isDeclined(event: $0) &&
                (query == nil || query! == "" || ($0.title ?? "").lowercased().contains(query!.lowercased()))
        }
        .prefix(5)
        .map { (event) -> NSDictionary in
            let title = event.title ?? "Untitled event"
            return [
                "title": title,
                "subtitle": "\(tomorrowLabel(date: event.startDate))\(dateFormatter.string(from: event.startDate))-\(dateFormatter.string(from: event.endDate))",
                "arg": toJSON(dict: [
                    "eventId": event.eventIdentifier ?? "",
                    "calendarId": event.calendar?.calendarIdentifier ?? "",
                    "title": title,
                ]),
            ]
        }
    let alfredEnvelope: NSDictionary = [
        "items": matchingEvents + [["title" : "Jump to Today", "subtitle" : "Open Today in Calendar", "arg": "{}"]]
    ]

    return alfredEnvelope
}

func getLinks(store: EKEventStore, calendars: [EKCalendar]) -> NSDictionary {
    let now = Date()
    let endOfDay = Calendar.current.startOfDay(for: now + 3600 * 24)
    let eventFilter = store.predicateForEvents(withStart: now, end: endOfDay, calendars: calendars)
    let links = store
        .events(matching: eventFilter)
        .filter { !$0.isAllDay && $0.status != .canceled && !isDeclined(event: $0) }
        .prefix(5)
        .flatMap { (event) -> [NSDictionary] in
            let allTextFields = "\(event.title ?? "")\n\(event.notes ?? "")\n\(event.location ?? "")\n\(event.url?.absoluteString ?? "")"
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            return detector
                .matches(in: allTextFields, options: [], range: NSMakeRange(0, allTextFields.count))
                .compactMap { (match) -> NSDictionary? in
                    if let url = match.url {
                        return [
                            "title": "\(event.title ?? "N/A") - \(urlName(url: url))",
                            "subtitle": url.absoluteString,
                            "arg": url.absoluteString,
                        ]
                    }
                    return nil
                }
        }
    let alfredEnvelope: NSDictionary = [
        "items": links + [["title" : "Jump to Today", "subtitle" : "Open Today in Calendar", "arg": ""]]
    ]

    return alfredEnvelope
}

func toJSON(dict: NSDictionary) -> String {
    let jsonData = try! JSONSerialization.data(withJSONObject: dict)
    if let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8) {
        return jsonResult
    }
    return ""
}

func fromJSON<T>(json: String) -> T? {
    return try? JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: []) as? T
}


func calendarsExceptThese(names: [String], store: EKEventStore) -> [EKCalendar] {
    return store
        .calendars(for: EKEntityType.event)
        .filter { !names.contains($0.title.trimmingCharacters(in: .whitespacesAndNewlines)) }
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

let env = ProcessInfo.processInfo.environment
let calendars: [EKCalendar] = calendarsExceptThese(names: fromJSON(json: env["IGNORE_CALENDARS", default: "[]"])!, store: store)

if (CommandLine.arguments.count > 1) {
    switch CommandLine.arguments[1] {
    case "events":
        print(toJSON(dict: getEvents(store: store, until: Date() + 3600 * 24, query: nil, calendars: calendars)))
    case "search":
        print(toJSON(dict: getEvents(store: store, until: Date() + 3600 * 24 * 30, query: CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "", calendars: calendars)))
    case "links":
        print(toJSON(dict: getLinks(store: store, calendars: calendars)))
    default:
        print("Unknown command. Known commands are: events, links.")
    }
} else {
    print("Run: \(CommandLine.arguments[0]) <events|links>")
}
