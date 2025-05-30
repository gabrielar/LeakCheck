# LeakCheck

LeakCheck is a Swift library that helps ensure classes are properly deallocated and not leaked.

[![Swift][swift-badge]][swift-url]
[![License][mit-badge]][mit-url]
[![GitHub Actions][gh-actions-badge]][gh-actions-url]

## Getting started

LeakCheck offers a `@TrackedInstances` property wrapper that, when applied to a class, lets you monitor how many instances of that class are currently alive. 

Note that instance tracking only occurs in DEBUG mode and after `AllocationLog.restart()` is called.

### Using LeakCheck

#### Checking by class type

Given a class `Bar` annotated as stated below:

```swift
@TrackedInstances
class Bar {
}
```

one can write the following test:

```swift
import XCTest
import LeakCheck

final class InstanceCountingTests: XCTestCase {

    func testCounting() throws {

        AllocationLog.restart()
        
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)
        var bar1: Bar? = Bar()
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        var bar2: Bar? = Bar()
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 2)
        bar1 = nil
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 1)
        bar2 = nil
        XCTAssertEqual(AllocationLog.countInstances(ofType: Bar.self), 0)

        AllocationLog.stop()
    }
}
```

#### Checking using a tag

If the class is private, one cannot use its type in tests. Hence the `@TrackedInstances` macro can accept a tag as argument.

Given a class `Bar` annotated as stated below:

```swift
@TrackedInstances(tag: "Bar")
class Bar {
}
```

one can write the following test:

```swift
import XCTest
import LeakCheck

final class InstanceCountingTests: XCTestCase {

    func testCounting() throws {

        AllocationLog.restart()
        
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)
        var bar1: TaggedBar? = TaggedBar(someOtherString: "test1")
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 1)
        var bar2: TaggedBar? = TaggedBar(someOtherString: "test2")
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 2)
        bar1 = nil
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 1)
        bar2 = nil
        XCTAssertEqual(try AllocationLog.countInstances(tag: "Bar"), 0)

        AllocationLog.stop()
    }
}
```

## License

This project is released under the MIT license. See [LICENSE](LICENSE) for details.

[swift-badge]: https://img.shields.io/badge/Swift-6.0-orange.svg?style=flat
[swift-url]: https://swift.org

[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license

[gh-actions-badge]: https://github.com/gabrielar/LeakCheck/actions/workflows/build.yml/badge.svg?branch=main
[gh-actions-url]: https://github.com/gabrielar/LeakCheck/actions?query=branch%3Amain++
