//
//  Clicker.swift
//  AutoClicker
//
//  Created by Preston Bryan on 11/3/19.
//  Copyright © 2019 Preston Bryan. All rights reserved.
//

import Cocoa
import Combine

class Clicker: ObservableObject {
    @Published var isActive: Bool = false
    var timer: Timer = Timer()
    @Published var clicks: Int = 0
    var interval: Double = 1.0
    var numberOfClicks: Int = 0
    
    func startClicker(interval: Double , numberOfClicks: Int) {
        if !self.isActive {
            self.isActive.toggle()
            let clicksPerSecond = 1000 / interval
            clicks = 0
            if numberOfClicks == 0 {
                timer = Timer.scheduledTimer(timeInterval: clicksPerSecond / 1000.0, target: self, selector: #selector(click), userInfo: nil, repeats: true)
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: clicksPerSecond / 1000.0, repeats: true) { timer in
                    self.click()
                    if self.clicks == numberOfClicks {
                        self.isActive.toggle()
                        timer.invalidate()
                    }
                }
            }
        }
    }
    func startClicker() {
        if !self.isActive {
            self.isActive.toggle()
            let clicksPerSecond = 1000 / self.interval
            clicks = 0
            if numberOfClicks == 0 {
                timer = Timer.scheduledTimer(timeInterval: clicksPerSecond / 1000.0, target: self, selector: #selector(click), userInfo: nil, repeats: true)
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: clicksPerSecond / 1000.0, repeats: true) { timer in
                    self.click()
                    if self.clicks == self.numberOfClicks {
                        self.isActive.toggle()
                        timer.invalidate()
                    }
                }
            }
        }
    }
        
    func stopClicker() {
        if self.isActive {
            self.isActive.toggle()
            timer.invalidate()
        }
    }
    
    
    @objc func click() {
        clicks += 1
        let event = CGEvent(source: CGEventSource(stateID: .hidSystemState))
        let location = event?.location

        let mouseDown = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown,
                                mouseCursorPosition: location!, mouseButton: .left)
        let mouseUp = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp,
                              mouseCursorPosition: location!, mouseButton: .left)
        mouseDown?.post(tap: .cghidEventTap)
        mouseUp?.post(tap: .cghidEventTap)
    }
}
