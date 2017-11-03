
public class CompletionOperation<T> {
    
    public typealias ResultClosure = (_ res: T) -> ()
    public typealias CompletionClosure = (_ completion: @escaping ResultClosure) -> ()
    
    fileprivate let operation: CompletionClosure
    
    public static func create<Type>(_ operation: @escaping CompletionOperation<Type>.CompletionClosure) -> CompletionOperation<Type>{
        return CompletionOperation<Type>(operation)
    }
    
    private init(_ operation: @escaping CompletionClosure) {
        self.operation = operation
    }
    
    public func observe(_ result: @escaping ResultClosure) {
        operation(result)
    }
    
    public func next(_ next: @escaping (_ value: T) -> ()) -> CompletionOperation<T>{
        
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
    
    public func convert<OtherType>(_ convertClosure: @escaping (_ value: T) -> (OtherType)) -> CompletionOperation<OtherType>{
        
        return CompletionOperation<OtherType>.create({ (completion) in
            
            self.observe({ (res) in
                let convRes = convertClosure(res)
                completion(convRes)
            })
            
        })
        
    }
}
