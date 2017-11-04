
public protocol EventProtocol {
    associatedtype EventType
    typealias EventHandler = (_ value:EventType) -> ()
    
    func subscibe(handler: @escaping EventHandler) -> EventSubscriberProtocol
    func raise(value:EventType)
}
