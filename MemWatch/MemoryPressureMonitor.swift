//
//  MemoryPressureMonitor.swift
//  MemWatch
//
//  Created by Janie Holzmann on 2026-10-25.
//

import Foundation
import Observation

enum MemoryPressureLevel: String, Sendable {
    case normal
    case warning
    case critical
}

@MainActor
@Observable
final class MemoryPressureMonitor {
    private(set) var level: MemoryPressureLevel = .normal

    private var source: DispatchSourceMemoryPressure?

    func start() {
        guard source == nil else { return }

        let source = DispatchSource.makeMemoryPressureSource(
            eventMask: [.normal, .warning, .critical],
            queue: .main
        )

        source.setEventHandler { [weak self, weak source] in
            guard let event = source?.data else { return }
            let newLevel: MemoryPressureLevel =
                event.contains(.critical) ? .critical :
                event.contains(.warning) ? .warning : .normal
            Task { @MainActor in
                self?.level = newLevel
            }
        }

        source.resume()
        self.source = source
    }

    func stop() {
        source?.cancel()
        source = nil
    }
}
