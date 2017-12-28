
public class CompletionOperation<T> {
    
//    public enum InternalError: Error {
//        case invalidErrorType
//    }
    
//    public enum ResultWithError {
//        case Success(r: T)
//        case Error(e: Error)
//    }
    
    public typealias ResultClosure = (_ res: T) -> ()
    public typealias CompletionClosure = (_ completion: @escaping ResultClosure) -> ()
    
    fileprivate let operation: CompletionClosure
    
    public static func create<Type>(_ operation: @escaping CompletionOperation<Type>.CompletionClosure) -> CompletionOperation<Type>{
        return CompletionOperation<Type>(operation)
    }
    
    public static func signal<Type>(_ array:[Type]) -> CompletionOperation<Type>{
        return CompletionOperation<Type>.create({ (completion) in
            for value in array {
                completion(value)
            }
        })
    }
    
    private init(_ operation: @escaping CompletionClosure) {
        self.operation = operation
    }
    
    public func observe(_ result: @escaping ResultClosure) {
        operation(result)
    }
    
    public func next(_ next: @escaping ResultClosure) -> CompletionOperation<T>{
        
        return CompletionOperation<T>.create({ (completion) in
            self.observe({ (res) in
                next(res)
                completion(res)
            })
        })
    }
    
    public func filter(_ filter: @escaping (_ value: T) -> (Bool)) -> CompletionOperation<T>{
        
        return CompletionOperation<T>.create({ (completion) in
            
            self.observe({ (res) in
                if (filter(res)) {
                    completion(res)
                }
            })
            
        })
    }
    
    public func map<OtherType>(_ mapClosure: @escaping (_ value: T) -> (OtherType)) -> CompletionOperation<OtherType>{
        
        return CompletionOperation<OtherType>.create({ (completion) in
            
            self.observe({ (res) in
                let convRes = mapClosure(res)
                completion(convRes)
            })
            
        })
        
    }
}
