// https://github.com/Quick/Quick

import Quick
import Nimble
import RxSwift
import Foundation

class RxSwiftTests: QuickSpec {
    
    override func spec() {
        
        context("RxSwift") {
            it("just") {
                
                let bag = DisposeBag()
                
                var result = ""
                
                Observable.just("Hello Rx").subscribe({ (event:Event<String>) in
                    
                    switch event {
                    case .next(let value):
                        result += "\(value);"
                    case .error:
                        result += "error;"
                    case .completed:
                        result += "completed;"
                    }
                }).disposed(by: bag)
               
                expect(result) == "Hello Rx;completed;"
            }
            
            it("publishSubject") {
                let bag = DisposeBag()
                
                var result = ""
                let publishSubject = PublishSubject<String>()
                publishSubject.subscribe({ (event:Event<String>) in
                    switch event {
                    case .next(let value):
                        result += "\(value);"
                    case .error:
                        result += "error;"
                    case .completed:
                        result += "completed;"
                    }
                }).disposed(by: bag)
                
                publishSubject.onNext("next 1")
                publishSubject.onNext("next 2")
                publishSubject.onCompleted()
                
                expect(result) == "next 1;next 2;completed;"
            }
            
            
            it("map") {
                
                let bag = DisposeBag()
                
                var result = ""
                
                Observable.of(1,2,3)
                    .map({ (i:Int) -> String in
                        return String(i)
                    }).subscribe({ (event:Event<String>) in
                        switch event {
                        case .next(let value):
                            result += "\(value);"
                        case .error:
                            result += "error;"
                        case .completed:
                            result += "completed;"
                        }
                    }).disposed(by: bag)
                
                expect(result) == "1;2;3;completed;"
            }
            
        }
        
    }
}

