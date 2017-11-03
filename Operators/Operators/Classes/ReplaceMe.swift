
class CompletionOperation<Result>: Operation {
    
    typealias CompletionWithResult = (_ res: Result) -> ()
    
    let operation: CompletionWithResult
    
//    public static func create<Type>(_ operation: @escaping CompletionWithResult) -> CompletionOperation<Type>{
//        return CompletionOperation<Type>(operation)
//    }
    
    private init(_ operation: @escaping CompletionWithResult) {
        self.operation = operation
    }
}
