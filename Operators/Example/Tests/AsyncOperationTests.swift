// https://github.com/Quick/Quick

import Quick
import Nimble
import Operators
import Foundation

class CompletionOperationTests: QuickSpec {
    override func spec() {
        
        it("Operation") {
            
            CompletionOperation<Int>.create({ (completion) in
                completion(5)
                completion(4)
            }).filter({ (value) -> (Bool) in
                return value < 6
            }).next({ (res:Int) in
                print("-> Next int: \(res)")
            }).convert({ (res: Int) -> (String) in
                return String(res)
            }).next({ (res:String) in
                print("-> Next str: \(res)")
            }).observe({ (res:String) in
                print("-> Result \(res)")
            })
            
        }
        
        it("Event") {
            let nc = NotificationCenter.default
            let name = Notification.Name("test")
            let event = NotificationCenterEvent<String>(nc, name:name)
            
            let subscriber1 = event.subscibe(handler: { (value:String) in
                print("-> Subscriber 1 \(value)")
            })
            
            let subscriber2 = event.subscibe(handler: { (value:String) in
                print("-> Subscriber 2 \(value)")
            })
            event.raise(value: "value")
            
            subscriber1.unsubsribe()
            
            event.raise(value: "next value")
            
            subscriber2.unsubsribe()
        }
    }
}
