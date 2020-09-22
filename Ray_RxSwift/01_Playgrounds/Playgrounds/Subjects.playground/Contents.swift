import Foundation
import RxSwift
import RxCocoa

example(of: "PublishSubject") {
    //Субьект подписанный на обновления и рассылающй информацию по подписчикам
    let subject = PublishSubject<String>()
    subject.onNext("Is anyone listening?")
    //Подписчик
    let subscriptionOne = subject
        .subscribe(onNext: { string in
            print(string)
        })
    
    subject.on(.next("1"))
    subject.onNext("2")
    
    let subscriptionTwo = subject
        .subscribe { event in
            print("2)", event.element ?? event)
    }
    
    subject.onNext("3")
    
    subscriptionOne.dispose()
    
    subject.onNext("4")
    
    // 1
    subject.onCompleted()
    
    // 2
    subject.onNext("5")
    
    // 3
    subscriptionTwo.dispose()
    
    let disposeBag = DisposeBag()
    
    // 4
    subject
        .subscribe {
            print("3)", $0.element ?? $0)
    }
    .disposed(by: disposeBag)
    
    subject.onNext("?")
}

// 1
enum MyError: Error {
    case anError
}

// 2
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}

// 3
example(of: "BehaviorSubject") {
    // 4
    let subject = BehaviorSubject(value: "Initial value")
    let disposeBag = DisposeBag()
    
    subject.onNext("X")
    
    subject
        .subscribe {
            print(label: "1)", event: $0)
    }
    .disposed(by: disposeBag)
    
    // 1
    subject.onError(MyError.anError)
    
    // 2
    subject
        .subscribe {
            print(label: "2)", event: $0)
    }
    .disposed(by: disposeBag)
}

example(of: "ReplaySubject") {
    // 1
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    
    // 2
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    // 3
    subject
        .subscribe {
            print(label: "1)", event: $0)
    }
    .disposed(by: disposeBag)
    
    subject
        .subscribe {
            print(label: "2)", event: $0)
    }
    .disposed(by: disposeBag)
    
    subject.onNext("4")
    
    subject.onError(MyError.anError)
    subject.dispose()
    
    subject
        .subscribe {
            print(label: "3)", event: $0)
    }
    .disposed(by: disposeBag)
}

example(of: "PublishRelay") {
    let relay = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    relay.accept("Knock knock, anyone home?")
    
    relay
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    relay.accept("1")
     relay.accept("2")
}

example(of: "BehaviorRelay") {
    // 1
    //let relay = BehaviorRelay(value: "Initial value")
    let relay = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()
    
    // 2
    relay.accept("New initial value")
    
    // 3
    relay
        .subscribe {
            print(label: "1)", event: $0)
    }
    .disposed(by: disposeBag)
    
    // 1
    relay.accept("1")
    
    // 2
    relay
        .subscribe {
            print(label: "2)", event: $0)
    }
    .disposed(by: disposeBag)
    
    // 3
    relay.accept("2")
    
    print(relay.value)
}




//MARK: - CHALLENGE 1

example(of: "Challenge 1: Create a blackjack card dealer using a publish subject") {
    
    let disposeBag = DisposeBag()
    let dealtHand = PublishSubject<[(String, Int)]>()
    
    func deal(_ cardCount: UInt) {
        var deck = cards
        var cardsRemaining = deck.count
        var hand = [(String, Int)]()
        
        for _ in 0..<cardCount {
            let randomIndex = Int.random(in: 0..<cardsRemaining)
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }
        
        // Add code to update dealtHand here
        let pointsTotal = points(for: hand)
        if pointsTotal <= 21 {
            dealtHand.onNext(hand)
        } else {
            dealtHand.onError(HandError.busted(points: pointsTotal))
        }
    }
    
    // Add subscription to dealtHand here
    dealtHand.subscribe (
        onNext: {
            print(cardString(for: $0), "for", points(for: $0), "points")
        },
        onError: {
            print(String(describing: $0).capitalized)
        }).disposed(by: disposeBag)
    
    deal(3)
}


//MARK: - CHALLENGE 2

example(of: "Observe and check user session state using a behavior relay") {
    
    enum UserSession {
        case loggedIn, loggedOut
    }
    
    enum LoginError: Error {
        case invalidCredentials
    }
    
    let disposeBag = DisposeBag()
    
    // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
    let userSession = BehaviorRelay(value: UserSession.loggedOut)
    
    // Subscribe to receive next events from userSession
    userSession.subscribe(
        onNext: {
            print("userSession changed:", $0)
        }).disposed(by: disposeBag)
    
    func logInWith(username: String, password: String, completion: (Error?) -> Void) {
        guard username == "johnny@appleseed.com",
              password == "appleseed" else {
            completion(LoginError.invalidCredentials)
            return
        }
        // Update userSession
        userSession.accept(UserSession.loggedIn)
    }
    
    func logOut() {
        // Update userSession
        userSession.accept(UserSession.loggedOut)
    }
    
    func performActionRequiringLoggedInUser(_ action: () -> Void) {
        // Ensure that userSession is loggedIn and then execute action()
        if userSession.value == .loggedIn {
            print("You can do that!")
            action()
        }
    }
    
    for i in 1...2 {
        let password = i % 2 == 0 ? "appleseed" : "password"
        
        logInWith(username: "johnny@appleseed.com", password: password) { error in
            guard error == nil else {
                print(error!)
                return
            }
            
            print("User logged in.")
        }
        
        performActionRequiringLoggedInUser {
            print("Successfully did something only a logged in user can do.")
        }
    }
}

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
