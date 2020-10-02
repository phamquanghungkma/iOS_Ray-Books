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
import RxCocoa
import RxTest
@testable import Testing

class TestingViewModel : XCTestCase {
  var viewModel: ViewModel!
  var scheduler: ConcurrentDispatchQueueScheduler!

  override func setUp() {
    super.setUp()

    viewModel = ViewModel()
    scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
  }

  func testColorIsRedWhenHexStringIsFF0000_async() {
    let disposeBag = DisposeBag()

    // 1 Create an expectation to be fulfilled later.
    let expect = expectation(description: #function)

    // 2 Create the expected test result expectedColor as equal to a red color.
    let expectedColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)

    // 3 Define the result to be later assigned.
    var result: UIColor!
 
    // 1 Create a subscription to the view model’s color driver. Notice that you skip the first one because Driver will replay the initial element upon subscription.
    viewModel.color.asObservable()
      .skip(1)
      .subscribe(onNext: {
        // 2 Assign the .next event element to result and call fulfill() on the expectation.
        result = $0
        expect.fulfill()
      })
      .disposed(by: disposeBag)

    // 3 Add a new value onto the view model’s hexString input observable (a BehaviorRelay).
    viewModel.hexString.accept("#ff0000")

    // 4 Wait for the expectation to fulfill with a 1 second timeout. In the closure, you guard for an error and then assert that the expected color equals the actual result.
    waitForExpectations(timeout: 1.0) { error in
      guard error == nil else {
        XCTFail(error!.localizedDescription)
        return
      }

      // 5 Result
      XCTAssertEqual(expectedColor, result)
    }
  }

  func testColorIsRedWhenHexStringIsFF0000() throws {
    // 1
    let colorObservable = viewModel.color.asObservable().subscribeOn(scheduler)

    // 2
    viewModel.hexString.accept("#ff0000")

    // 3
    XCTAssertEqual(try colorObservable.toBlocking(timeout: 1.0).first(),
                   .red)
  }

  func testRgbIs010WhenHexStringIs00FF00() throws {
    // 1 Create the colorObservable to hold on to the observable result of subscribing on the concurrent scheduler.
    let rgbObservable = viewModel.rgb.asObservable().subscribeOn(scheduler)

    // 2 Add a new value onto the view model’s hexString input observable.
    viewModel.hexString.accept("#00ff00")

    // 3 Block the observable and wait for the first element to be emitted, assering it to emit the expected color.
    let result = try rgbObservable.toBlocking().first()!

    XCTAssertEqual(0 * 255, result.0)
    XCTAssertEqual(1 * 255, result.1)
    XCTAssertEqual(0 * 255, result.2)
  }

  func testColorNameIsRayWenderlichGreenWhenHexStringIs006636() throws {
    // 1 Create rgbObservable to hold the subscription on the scheduler.
    let colorNameObservable = viewModel.colorName.asObservable().subscribeOn(scheduler)
 
    // 2 Add a new value onto the view model’s hexString input observable.
    viewModel.hexString.accept("#006636")

    // 3 Retrieve the first result of calling toBlocking on rgbObservable and then assert that each value matches expectations.
    XCTAssertEqual("rayWenderlichGreen", try colorNameObservable.toBlocking().first()!)
  }
}
