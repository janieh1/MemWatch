//
//  SystemMemoryReader.swift
//  MemWatch
//
//  Created by Janie Holzmann on 2026-10-25.
//

import Foundation

enum MemoryReadingError: Error {
    case readingFailed
}

struct SystemMemoryReader: MemorySnapshotProvider {
    
    func takeSnapshot() throws -> MemorySnapshot {
        var count = mach_msg_type_number_t(
            MemoryLayout<vm_statistics64>.stride / MemoryLayout<integer_t>.stride
        )

        var stats = vm_statistics64()

        let result = withUnsafeMutablePointer(to: &stats) { statsPtr in
            statsPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
                host_statistics64(mach_host_self(), HOST_VM_INFO64, intPtr, &count)
            }
        }
        
        if (result != KERN_SUCCESS) {
            throw MemoryReadingError.readingFailed
        }
        
        let pageSize = UInt64(getpagesize())
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        
        // measured in pages, to get bytes multiply number by page sizr
        let free = UInt64(stats.free_count) * pageSize
        let active = UInt64(stats.active_count) * pageSize
        let wire = UInt64(stats.wire_count) * pageSize
        let compress = UInt64(stats.compressor_page_count) * pageSize
        let inactive = UInt64(stats.inactive_count) * pageSize
        let intern = UInt64(stats.internal_page_count) * pageSize
        let purgatory = UInt64(stats.purgeable_count) * pageSize
        
        return MemorySnapshot(totalMemoryBytes: totalMemory, activeBytes: active, wiredBytes: wire, compressedBytes: compress, internalBytes: intern, purgatoryBytes: purgatory, freeBytes: free, inactiveBytes: inactive)
    }
    
}



