// https://github.com/Quick/Quick

import Quick
import Nimble
import Operators
import Foundation

class CompletionOperationTests: QuickSpec {
    public enum ResultWithError {
        case Success(r: String)
        case Error(e: Error)
        
        func isError() -> Bool {
            switch self {
            case .Success(_): return false
            case .Error(_): return true
            }
        }
        func successValue() -> String {
            switch self {
            case .Success(let value): return value
            case .Error(_): fatalError("Operation failed")
            }
        }
    }

    enum TestError: Error {
        case anyError
    }
    
    func throwCustomError(anyError: TestError) throws {
        throw anyError
    }
    
    override func spec() {
        
        
        context("Operation") {
            it("should observe operation") {
                var result:String = ""
                
                CompletionOperation<String>.signal(["5", "4"]).observe({ (value:String) in
                    result += "result \(value);"
                })
                
                expect(result) == "result 5;result 4;"
            }
            
            it("should filter results value") {
                var result:String = ""
                
                CompletionOperation<String>.signal([7,4]).filter({ (value:Int) -> (Bool) in
                    return value > 6
                }).observe({ (value:Int) in
                    result += "result \(value);"
                })
                expect(result) == "result 7;"
            }
            
            it("should next") {
                var result:String = ""
                
                CompletionOperation<String>.signal([4]).next({ (value:Int) in
                    result += "next1 \(value);"
                }).next({ (value:Int) in
                    result += "next2 \(value);"
                }).observe({ (value:Int) in
                    result += "result \(value);"
                })
                expect(result) == "next1 4;next2 4;result 4;"
            }
            
            it("should map value") {
                var result:String = ""
                
                CompletionOperation<String>.signal([4]).map({ (value:Int) -> (Int) in
                    return value + 10
                }).observe({ (value:Int) in
                    result += "result \(value);"
                })
                expect(result) == "result 14;"
            }
            
            it("should map value to other type") {
                var result:String = ""
                
                CompletionOperation<String>.signal([4]).map({ (value:Int) -> (String) in
                    return "str_\(value)"
                }).observe({ (value:String) in
                    result += "result \(value);"
                })
                expect(result) == "result str_4;"
            }
            
            it("should stop execution if errors") {
                var result:String = ""
                
                CompletionOperation<ResultWithError>.signal([ResultWithError.Success(r: "success"), ResultWithError.Error(e: TestError.anyError)])
                    .filter({ (res:ResultWithError) -> (Bool) in
                        result += "filter;"
                        return !res.isError()
                    }).map({ (res: ResultWithError) -> (String) in
                        return res.successValue()
                    }).observe({ (res:String) in
                        result += "result \(res);"
                    })
                
                expect(result) == "filter;result success;filter;"
            }
            
        }
        
        context("Event") {
            
            var testEvent: NotificationCenterEvent<String>!
            var testEventOther: NotificationCenterEvent<Int>!
            
            beforeEach {
                let notificationCenter:NotificationCenter  = NotificationCenter.default
                
                testEvent = NotificationCenterEvent<String>(notificationCenter, name:Notification.Name("test"))
                testEventOther = NotificationCenterEvent<Int>(notificationCenter, name:Notification.Name("test1"))
            }
            
            it("Habdle the subscribe event") {
                var result:String = ""
                var subscriberToTheEvent:EventSubscriberProtocol?
                var subscriberToTheEventOther:EventSubscriberProtocol?
                
                testEvent.subscibe(subscribed: { (subscriber) in
                    subscriberToTheEvent = subscriber
                }).observe({ (value:String) in
                    result += "result \(value);"
                })
                
                testEventOther.subscibe(subscribed: { (subscriber) in
                    subscriberToTheEventOther = subscriber
                }).observe({ (value:Int) in
                    result += "result int_\(value);"
                })
                
                testEvent.raise(value: "1")
                testEventOther.raise(value: 2)
                
                subscriberToTheEvent?.unsubsribe() //or equal subscriberToTheEvent = nil
                subscriberToTheEventOther?.unsubsribe() //or equal subscriberToTheEventOther = nil
                
                expect(result) == "result 1;result int_2;"
            }
            
            it("Habdle the unsubscribe event") {
                var result:String = ""
                var subscriberToTheEvent:EventSubscriberProtocol?
                
                testEvent.subscibe(subscribed: { (subscriber) in
                    subscriberToTheEvent = subscriber
                }).observe({ (value:String) in
                    result += "result \(value);"
                })
                
                subscriberToTheEvent?.unsubsribe() //or equal subscriberToTheEvent = nil
                
                testEvent.raise(value: "1")
                
                expect(result) == ""
            }
        }
        
    }
}
