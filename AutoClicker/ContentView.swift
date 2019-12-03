//
//  ContentView.swift
//  AutoClicker
//
//  Created by Preston Bryan on 11/3/19.
//  Copyright © 2019 Preston Bryan. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var clicker: Clicker
    
    @State private var clickSpeed: String = "1"
    @State private var clickCount: String = "0"
    @State private var showCSPopover: Bool = false
    @State private var showNOCPopover: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Button(action: {
                    self.showCSPopover.toggle()
                }) {
                    ZStack {
                        Circle().frame(width: 18, height: 18)
                            .foregroundColor(.gray)
                        Text("?")
                            .foregroundColor(.black)
                    }
                }.popover(isPresented: self.$showCSPopover, content: {
                    Text("Number of clicks per second\nDefault value of 1")
                    .padding()
                })
                    .buttonStyle(PlainButtonStyle())
                Text("Speed")
                TextField("", text: $clickSpeed)
                    .onReceive(Just(clickSpeed)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue { self.clickSpeed = filtered }
                        self.clicker.interval = Double(filtered) ?? 1
                }.frame(width: 70)
            }
            .padding(.horizontal)
            
            HStack(spacing: 10) {
                Button(action: {
                    self.showNOCPopover.toggle()
                }) {
                    ZStack {
                        Circle().frame(width: 18, height: 18)
                            .foregroundColor(.gray)
                        Text("?")
                            .foregroundColor(.black)
                    }
                }.popover(isPresented: self.$showNOCPopover, content: {
                    Text("Number of click that will be preformed\n0 for infinite\nDefault value of 0")
                    .padding()
                })
                    .buttonStyle(PlainButtonStyle())
                Text("Click Count")
                TextField("", text: $clickCount)
                    .onReceive(Just(clickCount)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue { self.clickCount = filtered }
                        self.clicker.numberOfClicks = Int(self.clickCount) ?? 0
                }.frame(width: 70)
            }
                .padding(.horizontal)
            
            HStack {
                Button(action: {
                    self.clicker.startClicker()
                }) {
                    ZStack {
                        Rectangle().frame(width: 90, height: 50)
                            .foregroundColor(.gray)
                        Text("Start")
                            .foregroundColor(.black)
                    }
                        .cornerRadius(10)
                }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(self.clicker.isActive)
                
                Button(action: {
                    self.clicker.stopClicker()
                }) {
                    ZStack {
                        Rectangle().frame(width: 90, height: 50)
                            .foregroundColor(.gray)
                        Text("Stop")
                            .foregroundColor(.black)
                    }
                        .cornerRadius(10)
                }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(!self.clicker.isActive)
            }
            
            Text("Number of clicks: \(self.clicker.clicks)")
            
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
