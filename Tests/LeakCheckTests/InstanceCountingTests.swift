//
//  InstanceCountingTests.swift
//  LeakCheck
//
//  Created by Gabriel Radu on 17.04.25.
//

import XCTest
import LeakCheck

final class InstanceCountingTests: XCTestCase {
    
    override func tearDownWithError() throws {
        allocationLog.stop()
    }

    func testCounting() throws {
        
        allocationLog.restart()
        
        #if DEBUG
        
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        var bar1: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 1)
        var bar2: Bar? = Bar(someOtherString: "test2")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 2)
        bar1 = nil
        XCTAssertNil(bar1) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 1)
        bar2 = nil
        XCTAssertNil(bar2) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        #else
        
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        var bar1: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        var bar2: Bar? = Bar(someOtherString: "test2")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        bar1 = nil
        XCTAssertNil(bar1) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        bar2 = nil
        XCTAssertNil(bar2) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        #endif
    }
    
    func testDifferentiatingBetweenTypes() throws {
        
        allocationLog.restart()
        
        #if DEBUG
        
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)

        var bar: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 1)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)

        var foo: Foo? = Foo()
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 1)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 1)

        foo = nil
        XCTAssertNil(foo) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 1)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)

        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)
        
        #else
        
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)

        var bar: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)

        var foo: Foo? = Foo()
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)

        foo = nil
        XCTAssertNil(foo) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)

        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(allocationLog.countInstances(ofType: Foo.self), 0)
        
        #endif
    }

    func testLogginOnlyWhenStarted() throws {
        
        #if DEBUG
        
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)

        var bar: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        allocationLog.restart()
        
        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 1)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        allocationLog.stop()

        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        allocationLog.restart()
        
        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 1)
        
        allocationLog.restart()
        
        let bar2 = Bar(someOtherString: "test2")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 1)
        
        #else
        
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)

        var bar: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        allocationLog.restart()
        
        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        allocationLog.stop()

        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        allocationLog.restart()
        
        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)
        
        allocationLog.restart()
        
        let bar2 = Bar(someOtherString: "test2")
        XCTAssertEqual(allocationLog.countInstances(ofType: Bar.self), 0)

        #endif
    }

}

@TrackedInstances
class Bar {
    let someString = "Hello, World!"
    let someOtherString: String
    init(someOtherString: String) {
        self.someOtherString = someOtherString
    }
}

@TrackedInstances
class Foo {
    let someString = "Hello, World!"
}
