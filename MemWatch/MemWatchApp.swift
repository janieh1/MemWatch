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
