
//public protocol EventProtocol {
//    associatedtype EventType
//    typealias EventHandler = (_ value:EventType) -> ()
//
//    func subscibe(handler: @escaping EventHandler) -> EventSubscriberProtocol
//    func raise(value:EventType)
//}

public class EventProtocol<T> {
    public typealias EventHandler = (_ value:T) -> ()
    
    public typealias SubscriberCreatedClosure = (_ subscriber: EventSubscriberProtocol) -> ()

    public func subscibe(subscribed: @escaping SubscriberCreatedClosure) -> CompletionOperation<(T)> {
        preconditionFailure("This method must be overridden")
    }
    
    public func raise(value:T) {
        preconditionFailure("This method must be overridden")
    }
}
