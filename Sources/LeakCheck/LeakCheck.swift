//
//  LeakCheck.swift
//  LeakCheck
//
//  Created by Gabriel Radu on 17.04.25.
//

import Foundation

@attached(member, names: named(__leakCheckInstanceTrackerProperty))
public macro TrackedInstances() = #externalMacro(module: "LeakCheckMacros", type: "TrackedInstancesMacro")

public struct TrackerStruct: ~Copyable {
    private let type: AnyObject.Type
    public init(type: AnyObject.Type) {
        self.type = type
        allocationLog.add(allocationOfType: type)
    }
    deinit {
        allocationLog.add(deallocationOfType: type)
    }
}

public class AllocationLog: @unchecked Sendable {
    
    enum Operation {
        case allocation(AnyObject.Type)
        case deallocation(AnyObject.Type)
    }
    
    private var log: [Operation] = []
    private var shouldLog: Bool = false
    
    let lock = NSLock()
    
    fileprivate init() {}
    
    public func add(allocationOfType type: AnyObject.Type) {
        lock.lock()
        defer { lock.unlock() }
        if shouldLog {
            log.append(.allocation(type))
        }
    }
    
    public func add(deallocationOfType type: AnyObject.Type) {
        lock.lock()
        defer { lock.unlock() }
        if shouldLog {
            log.append(.deallocation(type))
        }
    }
    
    public func countInstances(ofType type: AnyObject.Type) -> Int {
        lock.lock()
        defer { lock.unlock() }
        var counter = 0
        for operation in log {
            switch operation {
            case .allocation(let allocatedType):
                if allocatedType === type {
                    counter += 1
                }
            case .deallocation(let deallocatedType):
                if deallocatedType === type {
                    counter -= 1
                }
            }
        }
        return counter
    }
    
    public func restart() {
        lock.lock()
        defer { lock.unlock() }
        log.removeAll()
        shouldLog = true
    }
    
    public func stop() {
        lock.lock()
        defer { lock.unlock() }
        shouldLog = false
    }
}

public let allocationLog = AllocationLog()
