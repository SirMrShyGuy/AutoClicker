//
//  KeyBoardMonitor.swift
//  AutoClicker
//
//  Created by Preston Bryan on 11/20/19.
//  Copyright © 2019 Preston Bryan. All rights reserved.
//

import Cocoa
import Combine

class KeyBoardMonitor {
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent) -> Void
    private var globalMonitor: Any!
    private var localMonitor: Any!
    
    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    func start() {
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: self.mask, handler: self.handler)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: self.mask) { event in
            self.handler(event)
            return event
        }
    }
    
    func stop() {
        if globalMonitor != nil {
            NSEvent.removeMonitor(globalMonitor!)
        }
        if localMonitor != nil {
            NSEvent.removeMonitor(localMonitor!)
        }
    }
}
