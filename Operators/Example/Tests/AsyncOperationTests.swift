// https://github.com/Quick/Quick

import Quick
import Nimble
import Operators
import Foundation

class CompletionOperationTests: QuickSpec {
    override func spec() {
        
        
        context("Operation") {
            it("should observe operation") {
                var result:String = ""
                
                CompletionOperation<String>.signal(["5", "4"]).observe({ (value:String) in
                    result += "result \(value);"
                })
                
                expect(result) == "result 5;result 4;"
            }
            
            it("should filter") {
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
        }
        
        context("Event") {
            
            var testEvent: NotificationCenterEvent<String>!
            
            beforeEach {
                let nc = NotificationCenter.default
                let name = Notification.Name("test")
                
                testEvent = NotificationCenterEvent<String>(nc, name:name)
            }
            
            it("Habdle the subscribe event") {
                var result:String = ""
                var subscriberToTheEvent:EventSubscriberProtocol?
                
                testEvent.subscibe(subscribed: { (subscriber) in
                    subscriberToTheEvent = subscriber
                }).observe({ (value:String) in
                    result += "result \(value);"
                })
                
                testEvent.raise(value: "1")
                
                subscriberToTheEvent?.unsubsribe() //or equal subscriberToTheEvent = nil
                
                expect(result) == "result 1;"
            }
            
            it("Habdle the unsubscribe event") {
                var result:String = ""
                var subscriberToTheEvent:EventSubscriberProtocol?
                
                testEvent.subscibe(subscribed: { (subscriber) in
                    subscriberToTheEvent = subscriber
                }).observe({ (value:String) in
                    result += "result \(value);"
                })
                
                subscriberToTheEvent?.unsubsribe()
                testEvent.raise(value: "1")
                
                expect(result) == ""
            }
        }
        
    }
}
