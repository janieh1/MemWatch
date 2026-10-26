//
//  MemWatchApp.swift
//  MemWatch
//
//  Created by Janie Holzmann on 2026-10-25.
//

import SwiftUI

@main
struct MemWatchApp: App {
    @State private var monitor: MemoryPressureMonitor

    init() {
        let monitor = MemoryPressureMonitor()
        monitor.start()
        _monitor = State(initialValue: monitor)
        
        let snap = try?
        SystemMemoryReader().takeSnapshot()
        if let snap {
            print(Double(snap.usedBytes) / 1073741824.0)
            print(Double(snap.appMemoryBytes) / 1073741824.0)
            print(Double(snap.wiredBytes) / 1073741824.0)
            print(Double(snap.compressedBytes) / 1073741824.0)
        }
    }

    var body: some Scene {
        MenuBarExtra {
            Text("Memory pressure: \(monitor.level.rawValue.capitalized)")
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        } label: {
            Image(systemName: icon(for: monitor.level))
        }
    }

    private func icon(for level: MemoryPressureLevel) -> String {
        switch level {
        case .normal: "memorychip"
        case .warning: "exclamationmark.triangle"
        case .critical: "exclamationmark.octagon"
        }
    }
}
