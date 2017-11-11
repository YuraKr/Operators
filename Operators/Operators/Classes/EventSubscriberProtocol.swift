//public protocol EventSubscriberProtocol {
//    func unsubsribe()
//}


public class EventSubscriberProtocol {
    public init() {
        
    }
    
    public func unsubsribe(){
        preconditionFailure("Implement this abstract function")
    }
}
