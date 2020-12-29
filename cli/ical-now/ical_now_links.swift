#!/usr/bin/swift
import Foundation
import Darwin
import EventKit

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
let endOfDay = Calendar.current.startOfDay(for: now + 3600*24)
let eventFilter = store.predicateForEvents(withStart: now, end: endOfDay, calendars: nil)
let currentEvent = store
    .events(matching: eventFilter)
    .filter { !$0.isAllDay && $0.status != .canceled }
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

    let jsonData = try JSONSerialization.data(withJSONObject: alfredEnvelope)

    if let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8) {
        print(jsonResult)
    }
}
