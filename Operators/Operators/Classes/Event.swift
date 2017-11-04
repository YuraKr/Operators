

protocol EventProtocol {
    associatedtype EventType
    typealias EventHandler = (_ value:EventType) -> ()
    
    func subscibe(handler: @escaping EventHandler) -> EventSubscriberProtocol
    func raise(value:EventType)
}

protocol EventSubscriberProtocol {
    func unsubsribe()
}


public class NotificationCenterSubsciber<SubscriberType> : EventSubscriberProtocol {
    
    typealias EventHandler = (_ value:SubscriberType) -> ()
    
    let notificationCenter : NotificationCenter
    let notificationName : Notification.Name
    let handler: EventHandler
    
    init(_ notificationCenter: NotificationCenter, name:String, handler: @escaping EventHandler) {
        self.notificationCenter = notificationCenter
        self.notificationName = NSNotification.Name(name)
        notificationCenter.addObserver(self, selector: #selector(eventHandler(notification:)), name: notificationName, object: nil)
    }
    
    deinit {
        unsubsribe()
    }
    
    func unsubsribe() {
        notificationCenter.removeObserver(self)
    }
    
    @objc func eventHandler(notification: NSNotification) {
        guard let value = notification.object as? SubscriberType else {
            print("TODO: event data missing")
            return
        }
        handler(value)
    }
}

public class NotificationCenterEvent<T> : EventProtocol {
    typealias HandletType = T

    let notificationCenter : NotificationCenter
    let notificationName : Notification.Name

    init(_ notificationCenter: NotificationCenter, name:String, handler: @escaping EventHandler ) {
        self.notificationCenter = notificationCenter
        self.notificationName = NSNotification.Name(name)
    }

    public func subscibe(handler: @escaping EventHandler) -> EventSubscriberProtocol {
        let subscriber = NotificationCenterSubsciber(self.notificationCenter, name: self.notificationName, handler: handler)
        return subscriber
    }

    public func raise(value:T) {
        notificationCenter.post(name: notificationName, object: value)
    }
}
