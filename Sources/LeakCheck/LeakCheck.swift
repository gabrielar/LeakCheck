//
//  LeakCheck.swift
//  LeakCheck
//
//  Created by Gabriel Radu on 17.04.25.
//

import Foundation

@attached(member, names: named(__leakCheckInstanceTrackerProperty))
public macro TrackedInstances(tag: String? = nil) = #externalMacro(module: "LeakCheckMacros", type: "TrackedInstancesMacro")

public struct TrackerStruct: ~Copyable, Sendable {
    private let type: AnyObject.Type
    private let tag: String?
    public init(type: AnyObject.Type, tag: String? = nil) {
        self.type = type
        self.tag = tag
        AllocationLog.shared.add(allocationOfType: type, tag: tag)
    }
    deinit {
        AllocationLog.shared.add(deallocationOfType: type, tag: tag)
    }
}

public class AllocationLog: @unchecked Sendable {
    
    public enum Error: Swift.Error {
        case tagIsNotUnique(tag: String, types: [AnyObject.Type])
    }
    
    fileprivate static let shared = AllocationLog()

    enum Operation {
        case allocation(type: AnyObject.Type, tag: String?)
        case deallocation(type: AnyObject.Type, tag: String?)
    }
    
    private var log: [Operation] = []
    private var shouldLog: Bool = false
    
    let lock = NSLock()
    
    fileprivate init() {}
    
    public func add(allocationOfType type: AnyObject.Type, tag: String?) {
        lock.lock()
        defer { lock.unlock() }
        if shouldLog {
            log.append(.allocation(type: type, tag: tag))
        }
    }
    
    public func add(deallocationOfType type: AnyObject.Type, tag: String?) {
        lock.lock()
        defer { lock.unlock() }
        if shouldLog {
            log.append(.deallocation(type: type, tag: tag))
        }
    }
    
    private func countInstances(ofType type: AnyObject.Type) -> Int {
        lock.lock()
        defer { lock.unlock() }
        var counter = 0
        for operation in log {
            switch operation {
            case .allocation(let allocatedType, _):
                if allocatedType === type {
                    counter += 1
                }
            case .deallocation(let deallocatedType, _):
                if deallocatedType === type {
                    counter -= 1
                }
            }
        }
        return counter
    }
    public static func countInstances(ofType type: AnyObject.Type) -> Int {
        AllocationLog.shared.countInstances(ofType: type)
    }

    private func countInstances(tag: String) throws -> Int {
        lock.lock()
        defer { lock.unlock() }
        
        var typesForTag: [ObjectIdentifier: AnyObject.Type] = [:]
        var counter = 0
        for operation in log {
            switch operation {
            case .allocation(let allocatedType, let allocatedTag):
                if allocatedTag == tag {
                    counter += 1
                    typesForTag[ObjectIdentifier(allocatedType)] = allocatedType
                }
            case .deallocation(let deallocatedType, let allocatedTag):
                if allocatedTag == tag {
                    counter -= 1
                    typesForTag[ObjectIdentifier(deallocatedType)] = deallocatedType
                }
            }
        }
        if typesForTag.count > 1 {
            throw Error.tagIsNotUnique(tag: tag, types: typesForTag.values.map(\.self))
        }
        return counter
    }
    public static func countInstances(tag: String) throws -> Int {
        try AllocationLog.shared.countInstances(tag: tag)
    }

    private func restart() {
        lock.lock()
        defer { lock.unlock() }
        log.removeAll()
        shouldLog = true
    }
    public static func restart() {
        AllocationLog.shared.restart()
    }
    
    private func stop() {
        lock.lock()
        defer { lock.unlock() }
        shouldLog = false
    }
    public static func stop() {
        AllocationLog.shared.stop()
    }
}

