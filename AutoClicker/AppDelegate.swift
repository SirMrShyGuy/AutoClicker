//
//  AppDelegate.swift
//  AutoClicker
//
//  Created by Preston Bryan on 11/3/19.
//  Copyright © 2019 Preston Bryan. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var windowIsActive: Bool = false
    
    let clicker: Clicker = Clicker()
    
    var keyboardMonitor: KeyBoardMonitor!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        keyboardMonitor = KeyBoardMonitor(mask: .keyDown) { event in
            if event.keyCode == 80 { // 80 is hard coded to F19
                if self.clicker.isActive {
                    self.clicker.stopClicker()
                    print("clicker stoped")
                } else if !self.clicker.isActive {
                    self.clicker.startClicker()
                    print("clicker started")
                }
            }
        }
        keyboardMonitor.start()
        
        let contentView = ContentView().environmentObject(clicker)
        statusItem.button?.title = "AutoClicker"
        
        let statusMenu = NSMenu()
        statusMenu.addItem(NSMenuItem(title: "Settings", action: #selector(preferencesClicked(sender:)), keyEquivalent: ""))
        statusMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quitPressed(sender:)), keyEquivalent: ""))
        
        statusItem.menu = statusMenu
    
        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.title = "Auto Clicker"
        window.delegate = self
        window.contentView = NSHostingView(rootView: contentView)
//        window.makeKeyAndOrderFront(nil)
        window.level = .floating
        window.isReleasedWhenClosed = false // app will crash when reopening window without setting to false
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        keyboardMonitor.stop()
    }
    
    @objc func preferencesClicked(sender: NSMenuItem)  {
        // open prefernece window
        window.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
        windowIsActive = true
    }
    
    @objc func quitPressed(sender: NSMenuItem) {
        // quit application
        NSApp.terminate(self)
    }
    
    func windowWillClose(_ notification: Notification) {
        windowIsActive = false
    }


}

