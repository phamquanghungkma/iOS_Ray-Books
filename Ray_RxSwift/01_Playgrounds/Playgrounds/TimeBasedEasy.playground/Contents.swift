import Foundation
import RxSwift
import RxCocoa


example(of: "Timer") {
    let sourceObservable = Observable<Int>
        .interval(.seconds(1), scheduler: MainScheduler.instance)
        .map { $0 + 1 }
        .map { print("\($0) seconds") }
    
    let _ = sourceObservable.subscribe()
}

