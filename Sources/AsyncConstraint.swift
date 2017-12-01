import Foundation

/**
 A structrure that links an `AsyncPredicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public struct AsyncConstraint<T> {
    
    private var predicateBuilder: (T, DispatchQueue, @escaping (Bool) -> Void) -> Void
    private var errorBuilder: (T)->Error

    var conditions =  [AsyncConstraint<T>]()

    /**
     Create a new `AsyncConstraint` instance
     
     - parameter predicate: An `AsyncPredicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P:AsyncPredicate>(predicate:P, error:Error) where P.InputType == T {
        
        predicateBuilder = predicate.evaluate
        errorBuilder = { _ in return error }
    }
    
    /**
     Create a new `AsyncConstraint` instance
     
     - parameter predicate: An `AsyncPredicate` to describes the evaluation rule.
     - parameter error: An generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P:AsyncPredicate>(predicate:P, error: @escaping (T)->Error) where P.InputType == T {
        
        predicateBuilder = predicate.evaluate
        errorBuilder = error
    }

    public mutating func add(condition:AsyncConstraint<T>) {
        conditions.append(condition)
    }

    /**
     Asynchronous evaluates the input on the `Predicate`.
     
     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter result: `.valid` if the input is valid, `.invalid` containing the `Error` registered with the failing `Constraint` otherwise.
     */
    public func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (_ result:Result) -> Void) {

        if (!hasConditions()) {
            return continueEvaluate(with: input, queue: queue, completionHandler: completionHandler)
        }

        let predicateSet = AsyncConstraintSet(constraints: conditions)
        predicateSet.evaluateAll(input: input, queue: queue) { result in

            if result.isValid {
                return self.continueEvaluate(with: input, queue: queue, completionHandler: completionHandler)
            }

            completionHandler(result)
        }
    }

    private func hasConditions() -> Bool {
        return conditions.count > 0
    }

    private func continueEvaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (_ result:Result) -> Void) {

        predicateBuilder(input, queue) { matches in

            if matches {
                completionHandler(.valid)
            }
            else {
                let error = self.errorBuilder(input)
                let summary = Result.Summary(errors: [error])
                completionHandler(.invalid(summary))
            }
        }
    }
}
