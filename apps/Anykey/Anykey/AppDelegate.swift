//
//  AppDelegate.swift
//  Anykey
//
//  Created by Artem Chistyakov on 2/8/21.
//

import Cocoa
import FileWatcher
import OSLog
import ShellOut
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var preferencesWindow: NSWindow!
    private var statusItem: NSStatusItem?
    private var keyboardListener: HotkeyListener!
    private var config: HotkeyConfig!
    private var fileWatcher: FileWatcher!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        loadConfig()
        setupFileWatcher()
        setupHotkeys()
        setupStatusMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func setupHotkeys() {
        self.keyboardListener = HotkeyListener(onHotkey: { modifiers, key in
            if let hotkey = self.config.find(modifiers: modifiers, key: key) {
                DispatchQueue.global().async {
                    do {
                        try shellOut(to: hotkey.shellCommand)
                    } catch {
                        let error = error as! ShellOutError
                        os_log("Shell command error: %s", log: OSLog.default, type: .debug, error.message)
                        os_log("Shell command output: %s", log: OSLog.default, type: .error, error.output)
                    }
                }
                return true
            }
            return false
        })
    }

    @objc func showPreferences() {
        // Create the SwiftUI view that provides the window contents.
        let contentView = PreferencesView()

        // Create the window and set the content view.
        preferencesWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        preferencesWindow.title = "Anykey Preferences"

        preferencesWindow.isReleasedWhenClosed = false
        preferencesWindow.center()
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindow.makeKeyAndOrderFront(nil)
        preferencesWindow.setFrameAutosaveName("Anykey Preferences")
        preferencesWindow.contentView = NSHostingView(rootView: contentView)
    }

    
    private func setupStatusMenu() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let preferencesMenuItem = NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showPreferences), keyEquivalent: ",")
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "q")
        let menu = NSMenu()
        menu.addItem(preferencesMenuItem)
        menu.addItem(quitMenuItem)
        self.statusItem!.menu = menu
        self.statusItem!.button?.title = "⌘"
    }
    
    private func configPath() -> String {
        return NSString(string: "~/.Anykey.json").expandingTildeInPath
    }
    
    private func loadConfig() {
        do {
            os_log("Reloading hotkey config at %s", log: OSLog.default, type: .debug, self.configPath())
            config = try HotkeyConfig(filePath: configPath())
        } catch {
            os_log("Error when loading the config at %s", log: OSLog.default, type: .error, self.configPath())
            guard config != nil else { return }
            config = HotkeyConfig()
            
        }
    }
    
    private func setupFileWatcher() {
        fileWatcher = FileWatcher([configPath()])
        fileWatcher.queue = DispatchQueue.global()
        fileWatcher.callback = { _ in self.loadConfig() }
        fileWatcher.start()
    }
}
