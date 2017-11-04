import Foundation

public class NotificationCenterSubsciber<SubscriberType> : EventSubscriberProtocol {
    
    typealias EventHandler = (_ value:SubscriberType) -> ()
    
    let notificationCenter : NotificationCenter
    let notificationName : Notification.Name
    var handler: EventHandler?
    
    init(_ notificationCenter: NotificationCenter, name:NSNotification.Name, handler: @escaping EventHandler) {
        self.notificationCenter = notificationCenter
        self.notificationName = name
        self.handler = handler
        notificationCenter.addObserver(self, selector: #selector(eventHandler(notification:)), name: notificationName, object: nil)
    }
    
    deinit {
        unsubsribe()
    }
    
    public func unsubsribe() {
        self.notificationCenter.removeObserver(self)
        self.handler = nil
    }
    
    @objc func eventHandler(notification: NSNotification) {
        guard let value = notification.object as? SubscriberType else {
            print("TODO: event data missing")
            return
        }
        
        if let handler = self.handler {
            handler(value)
        }
    }
}
