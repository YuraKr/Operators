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
            
            it("Event") {
                let nc = NotificationCenter.default
                let name = Notification.Name("test")
                
                let event = NotificationCenterEvent<String>(nc, name:name)
                
                let subscriber1 = event.subscibe(handler: { (value:String) in
                    print("-> Subscriber 1 \(value)")
                })
                
                event.raise(value: "value")
                subscriber1.unsubsribe()
            }
            
            it("Habdle Event") {
                let nc = NotificationCenter.default
                let name = Notification.Name("test")
                
                let event = NotificationCenterEvent<String>(nc, name:name)
                var subscriber: EventSubscriberProtocol?
                
                CompletionOperation<String>.create({ (completion) in
                    
                    subscriber = event.subscibe(handler: { (value:String) in
                        completion(value)
                    })
                    
                    completion("11")
                }).observe({ (res:String) in
                    print("-> Result \(res)")
                })
                
                event.raise(value: "value")
                
                subscriber?.unsubsribe();
            }
        }
        
    }
}
