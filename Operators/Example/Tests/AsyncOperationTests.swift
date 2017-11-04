// https://github.com/Quick/Quick

import Quick
import Nimble
import Operators

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
            
            Event<>
            
        }
    }
}
