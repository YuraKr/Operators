import Foundation

public class NotificationCenterEvent<T> : EventProtocol {
    public typealias EventType = T

    let notificationCenter : Foundation.NotificationCenter
    let notificationName : NSNotification.Name

    public init(_ notificationCenter: NotificationCenter, name:NSNotification.Name ) {
        self.notificationCenter = notificationCenter
        self.notificationName = name
    }

    public func subscibe(handler: @escaping EventHandler) -> EventSubscriberProtocol {
        let subscriber = NotificationCenterSubsciber<T>(self.notificationCenter, name: self.notificationName, handler: handler)
        return subscriber
    }

    public func raise(value:T) {
        notificationCenter.post(name: notificationName, object: value)
    }
}
