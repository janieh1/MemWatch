//
//  MemorySnapshot.swift
//  MemWatch
//
//  Created by Janie Holzmann on 2026-10-25.
//

struct MemorySnapshot: Sendable {
    let totalMemoryBytes: UInt64
    let activeBytes: UInt64
    let wiredBytes: UInt64
    let compressedBytes: UInt64
    let internalBytes: UInt64
    let purgatoryBytes: UInt64
    let freeBytes: UInt64
    let inactiveBytes: UInt64
    
    var appMemoryBytes: UInt64 {
        internalBytes - purgatoryBytes
    }
    
    // used = appMem + wired + compressed (approximate)
    var usedBytes: UInt64 {
        appMemoryBytes + wiredBytes + compressedBytes
    }

}

protocol MemorySnapshotProvider: Sendable {
    func takeSnapshot() throws -> MemorySnapshot
}
