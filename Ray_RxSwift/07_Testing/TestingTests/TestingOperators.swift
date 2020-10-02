/*:
 Copyright (c) 2019 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import XCTest
import RxSwift
import RxTest
import RxBlocking

class TestingOperators : XCTestCase {
    var scheduler: TestScheduler!
    var subscription: Disposable!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        scheduler.scheduleAt(1000) {
            self.subscription.dispose()
        }
        super.tearDown()
    }
    
    // 1 As with all tests using XCTest, the method name must begin with test. You stub out a new test here of the amb operator.
    func testAmb() {
        // 2 You create an observer using the scheduler’s createObserver(_:) method, with a type hint of String.
        let observer = scheduler.createObserver(String.self)
        
        // 1 Create an observable A using the scheduler’s createHotObservable(_:) method. Like the previous special Observer, this is a special kind of Observable called TestableObservable, made speciifcally for RxTest tests.
        let observableA = scheduler.createHotObservable([
            // 2 Use Recorded.next(_:_:) to add .next events onto observableA at the designated virtual times with the value passed as the second parameter.
            Recorded.next(100, "a"),
            Recorded.next(200, "b"),
            Recorded.next(300, "c")
        ])
        
        // 3 Create a observableB hot observable.
        let observableB = scheduler.createHotObservable([
            // 4 Add .next events to observableB at the designated times and with the specified values.
            Recorded.next(90, "1"),
            Recorded.next(200, "2"),
            Recorded.next(300, "3")
        ])
        
        let ambObservable = observableA.amb(observableB)
        
        self.subscription = ambObservable.subscribe(observer)
        
        scheduler.start()
        
        let results = observer.events.compactMap {
            $0.value.element
        }
        
        XCTAssertEqual(results, ["1", "2", "3"])
    }
    
    func testFilter() {
        // 1 Create an observer, this time with a generic type of Int.
        let observer = scheduler.createObserver(Int.self)
        
        // 2 Create a hot observable that schedules a .next event every virtual second for a total 5 virtual seconds.
        let observable = scheduler.createHotObservable([
            Recorded.next(100, 1),
            Recorded.next(200, 2),
            Recorded.next(300, 3),
            Recorded.next(400, 2),
            Recorded.next(500, 1)
        ])
        
        // 3  Create the filterObservable to hold the result of using filter on observable with a predicate that requires the element value to be less than 3.
        let filterObservable = observable.filter {
            $0 < 3
        }
        
        // 4 Schedule the subscription to start at time 0 and assign it to the subscription property so it will be disposed of in tearDown().
        scheduler.scheduleAt(0) {
            self.subscription = filterObservable.subscribe(observer)
        }
        
        // 5 Start the scheduler.
        scheduler.start()
        
        // 6 Collect the results.
        let results = observer.events.compactMap {
            $0.value.element
        }
        
        // 7 Assert that the results are what you expected.
        XCTAssertEqual(results, [1, 2, 2, 1])
    }
    
    func testToArray() throws {
        // 1
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        
        // 2
        let toArrayObservable = Observable.of(1, 2).subscribeOn(scheduler)
        
        // 3
        XCTAssertEqual(try toArrayObservable.toBlocking().toArray(), [1, 2])
    }
    
    func testToArrayMaterialized() {
        // 1 Create a scheduler and observable to test, the same as in the previous test.
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        
        let toArrayObservable = Observable.of(1, 2).subscribeOn(scheduler)
        
        // 2  Call toBlocking and materialize on the observable, and assign the result to a local constant result.
        let result = toArrayObservable
            .toBlocking()
            .materialize()
        
        // 3 witch on result and handle each case.
        switch result {
        case .completed(let elements):
            XCTAssertEqual(elements,  [1, 2])
        case .failed(_, let error):
            XCTFail(error.localizedDescription)
        }
    }
}
