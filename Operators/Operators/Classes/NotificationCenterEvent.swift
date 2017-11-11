import Foundation

public class NotificationCenterEvent<T> : EventProtocol<T> {

    let notificationCenter : Foundation.NotificationCenter
    let notificationName : NSNotification.Name

    public init(_ notificationCenter: NotificationCenter, name:NSNotification.Name ) {
        self.notificationCenter = notificationCenter
        self.notificationName = name
    }

    override public func subscibe(handler: @escaping EventProtocol<T>.EventHandler) -> EventSubscriberProtocol {
        let subscriber = NotificationCenterSubsciber<T>(self.notificationCenter, name: self.notificationName, handler: handler)
        return subscriber
    }

    override public func raise(value:T) {
        notificationCenter.post(name: notificationName, object: value)
    }
}
