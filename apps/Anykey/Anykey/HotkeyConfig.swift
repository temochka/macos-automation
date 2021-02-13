//
//  HotkeyConfig.swift
//  Anykey
//
//  Created by Artem Chistyakov on 2/10/21.
//

import Cocoa
import Foundation

enum ConfigError : Error {
    case invalid(String)
}

func parseModifier(mod: String) throws -> NSEvent.ModifierFlags {
    switch mod {
    case "option", "opt", "⌥":
        return .option
    case "command", "cmd", "⌘":
        return .command
    case "control", "ctrl", "⌃":
        return .control
    case "shift", "⇧":
        return .shift
    default:
        throw ConfigError.invalid("Invalid modifier: \(mod)")
    }
}

struct Hotkey {
    let key: UInt32
    let modifiers: NSEvent.ModifierFlags
    let shellCommand: String
    let title: String
    let onlyIn: [String]

    init(json: [String: Any]) throws {
        guard let jsonTitle = json["title"] as? String else {
            throw ConfigError.invalid("Invalid or missing field: title")
        }
        guard let jsonKey = json["key"] as? String else {
            throw ConfigError.invalid("Invalid or missing field: key")
        }
        guard let jsonModifiers = json["modifiers"] as? [String] else {
            throw ConfigError.invalid("Invalid or missing field: value")
        }
        guard let jsonShellCommand = json["shellCommand"] as? String else {
            throw ConfigError.invalid("Invalid or missing field: shellCommand")
        }
        guard let jsonOnlyIn = json["onlyIn"] == nil ? Optional.some([]) : json["onlyIn"] as? [String] else {
            throw ConfigError.invalid("Invalid field value: onlyIn")
        }
        key = Key(string: jsonKey)!.carbonKeyCode
        modifiers = NSEvent.ModifierFlags(try! jsonModifiers.map(parseModifier))
        shellCommand = jsonShellCommand
        title = jsonTitle
        onlyIn = jsonOnlyIn
    }
}

class HotkeyConfig {
    let hotkeys: [Hotkey]

    init(filePath: String) throws {
        let url = URL(fileURLWithPath: filePath)
        if let data = try? Data(contentsOf: url),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let hotkeysJson = json["hotkeys"] as? [[String: Any]] {
           hotkeys = hotkeysJson.map { hotkeyJson in try! Hotkey(json: hotkeyJson) }
        } else {
            throw ConfigError.invalid("Failed to load the config")
        }
    }

    init() {
        hotkeys = []
    }

    func find(modifiers: NSEvent.ModifierFlags, key: UInt32) -> Hotkey? {
        let frontmostAppBundleId = NSWorkspace.shared.frontmostApplication?.bundleIdentifier ?? ""

        return hotkeys.first(where: { hotkey in hotkey.key == key && hotkey.modifiers == modifiers && (hotkey.onlyIn.isEmpty || hotkey.onlyIn.contains(frontmostAppBundleId)) })
    }
}
