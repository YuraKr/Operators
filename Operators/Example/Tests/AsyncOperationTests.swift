// https://github.com/Quick/Quick

import Quick
import Nimble
import Operators

class AsyncOperationTests: QuickSpec {
    override func spec() {
        
        it("Operation") {
            
            CompletionOperation<Int>.create({ (completion) in
                completion(5)
            }).convert({ (res: Int) -> (String) in
                return String(res)
            }).observe({ (res:String) in
                print("Success. Result \(res)")
            })
            
        }
    }
}
