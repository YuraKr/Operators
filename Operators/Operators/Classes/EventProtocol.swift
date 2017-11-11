
//public protocol EventProtocol {
//    associatedtype EventType
//    typealias EventHandler = (_ value:EventType) -> ()
//
//    func subscibe(handler: @escaping EventHandler) -> EventSubscriberProtocol
//    func raise(value:EventType)
//}

public class EventProtocol<T> {
    public typealias EventHandler = (_ value:T) -> ()
    
    public func subscibe(handler: @escaping EventHandler) -> EventSubscriberProtocol {
        preconditionFailure("This method must be overridden")
    }
    
    public func raise(value:T) {
        preconditionFailure("This method must be overridden")
    }
}
