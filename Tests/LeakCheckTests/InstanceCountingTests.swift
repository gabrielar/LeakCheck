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
        AllocationLog.stop()
    }

    func testCountingTypes() throws {
        
        AllocationLog.restart()
        
        #if DEBUG
        
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        var bar1: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        var bar2: Bar? = Bar(someOtherString: "test2")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 2)
        bar1 = nil
        XCTAssertNil(bar1) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        bar2 = nil
        XCTAssertNil(bar2) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        #else
        
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        var bar1: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        var bar2: Bar? = Bar(someOtherString: "test2")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        bar1 = nil
        XCTAssertNil(bar1) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        bar2 = nil
        XCTAssertNil(bar2) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        #endif
    }

    func testCountingTags() throws {
        
        AllocationLog.restart()
        
        #if DEBUG
        
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)
        var bar1: TaggedBar? = TaggedBar(someOtherString: "test1")
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 1)
        var bar2: TaggedBar? = TaggedBar(someOtherString: "test2")
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 2)
        bar1 = nil
        XCTAssertNil(bar1) // silences warning
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 1)
        bar2 = nil
        XCTAssertNil(bar2) // silences warning
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)
        
        #else
        
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)
        var bar1: TaggedBar? = TaggedBar(someOtherString: "test1")
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)
        var bar2: TaggedBar? = TaggedBar(someOtherString: "test2")
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)
        bar1 = nil
        XCTAssertNil(bar1) // silences warning
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)
        bar2 = nil
        XCTAssertNil(bar2) // silences warning
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)
        
        #endif
    }

    func testDifferentiatingBetweenTypes() throws {
        
        AllocationLog.restart()
        
        #if DEBUG
        
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)

        var bar: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)

        var foo: Foo? = Foo()
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 1)

        foo = nil
        XCTAssertNil(foo) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)

        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)
        
        #else
        
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)

        var bar: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)

        var foo: Foo? = Foo()
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)

        foo = nil
        XCTAssertNil(foo) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)

        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        XCTAssertEqual(AllocationLog.countInstances(ofType: Foo.self), 0)
        
        #endif
    }

    func testLogginOnlyWhenStarted() throws {
        
        #if DEBUG
        
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)

        var bar: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        AllocationLog.restart()
        
        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        AllocationLog.stop()

        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        AllocationLog.restart()
        
        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        
        AllocationLog.restart()
        
        let bar2 = Bar(someOtherString: "test2")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        
        #else
        
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)

        var bar: Bar? = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        AllocationLog.restart()
        
        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        AllocationLog.stop()

        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        bar = nil
        XCTAssertNil(bar) // silences warning
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        AllocationLog.restart()
        
        bar = Bar(someOtherString: "test1")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        
        AllocationLog.restart()
        
        let bar2 = Bar(someOtherString: "test2")
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)

        #endif
    }

    func testCountingWithDuplicateTags() throws {
        
        AllocationLog.restart()
        
        #if DEBUG
        
        XCTAssertEqual(try! AllocationLog.countInstances(tag: "Bar"), 0)
        let tb1 = TaggedBar(someOtherString: "test1"); _ = tb1
        XCTAssertEqual(try! AllocationLog.countInstances(tag: "Bar"), 1)
        let tb2 = TaggedBar2(someOtherString: "test2"); _ = tb2
        
        XCTAssertThrowsError(try AllocationLog.countInstances(tag: "Bar")) { error in
            guard let allocationLogError = error as? AllocationLog.Error else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            switch allocationLogError {
            case .tagIsNotUnique(let tag, let types):
                XCTAssert(tag == "Bar")
                XCTAssert(types.count == 2)
                let expectedTypes: [AnyObject.Type]  = [TaggedBar.self, TaggedBar2.self]
                XCTAssert(expectedTypes.contains { $0 === types[0] } )
                XCTAssert(expectedTypes.contains { $0 === types[1] } )
            }
        }
        
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


@TrackedInstances(tag: "Bar")
class TaggedBar {
    let someString = "Hello, World!"
    let someOtherString: String
    init(someOtherString: String) {
        self.someOtherString = someOtherString
    }
}

@TrackedInstances(tag: "Bar")
class TaggedBar2 {
    let someString = "Hello, World!"
    let someOtherString: String
    init(someOtherString: String) {
        self.someOtherString = someOtherString
    }
}
