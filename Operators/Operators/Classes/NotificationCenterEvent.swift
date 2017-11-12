import Foundation

public class NotificationCenterEvent<T> : EventProtocol<T> {
    
    let notificationCenter : Foundation.NotificationCenter
    let notificationName : NSNotification.Name

    public init(_ notificationCenter: NotificationCenter, name:NSNotification.Name ) {
        self.notificationCenter = notificationCenter
        self.notificationName = name
    }

    fileprivate func subscibe(handler: @escaping EventProtocol<T>.EventHandler) -> EventSubscriberProtocol {
        let subscriber = NotificationCenterSubsciber<T>(self.notificationCenter, name: self.notificationName, handler: handler)
        return subscriber
    }
    
    // subscribeOperation() -> (completionOperation, subscriber)
    public override func subscibe(subscribed: @escaping EventProtocol<T>.SubscriberCreatedClosure) -> CompletionOperation<T> {
        
        let subscribeOperation = CompletionOperation<T>.create { (completion: @escaping CompletionOperation<T>.ResultClosure) in
            let subscriber = self.subscibe { (value:T) in
                
                completion(value)
            }
            subscribed(subscriber)
        }
        return subscribeOperation
    }

    override public func raise(value:T) {
        notificationCenter.post(name: notificationName, object: value)
    }
}
