//
//  LeakCheckTests.swift
//  LeakCheck
//
//  Created by Gabriel Radu on 17.04.25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(LeakCheckMacros)
import LeakCheckMacros

let testMacros: [String: Macro.Type] = [
    "TrackedInstances": TrackedInstancesMacro.self,
]
#endif

final class TrackedInstancesMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(LeakCheckMacros)
        
        #if DEBUG
        let expandedSource = """
            class Foo {
            
                let __leakCheckInstanceTrackerProperty = LeakCheck.TrackerStruct(type: Foo.self)
            }
            """
        #else
        let expandedSource = """
            class Foo {
            }
            """
        #endif
        
        assertMacroExpansion(
            """
            @TrackedInstances
            class Foo {
            }
            """,
            expandedSource: expandedSource,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
