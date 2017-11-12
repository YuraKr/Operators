// https://github.com/Quick/Quick

import Quick
import Nimble
import Operators
import Foundation

class CompletionOperationTests: QuickSpec {
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
            
            it("should handle no errors operation completion") {
                var result:String = ""
                
                typealias ResultWithError = CompletionOperation<String>.ResultWithError
                
                CompletionOperation<String>.signal([ResultWithError.Success(r: "success"), ResultWithError.Error(e: TestError.anyError)])
                    .checkError({ (error:Error) in
                        result += "result error;"
                    }).observe({ (res:String) in
                        result += "result \(res);"
                    })
                
                expect(result) == "result success;result error;"
            }
            
            it("should handle errors") {
                var result:String = ""
                
                typealias ResultWithError = CompletionOperation<String>.ResultWithError
                
                CompletionOperation<String>.signal([ResultWithError.Success(r: "success"), ResultWithError.Error(e: TestError.anyError)])
                    .checkError({ (error:Error) in
                        result += "result error;"
                    }).observe({ (res:String) in
                        result += "result \(res);"
                    })
                
                expect(result) == "result success;result error;"
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
