import XCTest
import ValidationToolkit

class AsyncConstraintSetTests: XCTestCase {
    
    var constraints: AsyncConstraintSet<Int>!
    
    override func setUp() {
        super.setUp()
        constraints = AsyncConstraintSet<Int>()
    }
    
    func testItCanBeInstantiated() {
    
        XCTAssertNotNil(constraints)
        XCTAssertEqual(constraints.count, 0)
    }
    
    func testItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        
        let constraints = AsyncConstraintSet<Int>(constraints: [])
        XCTAssertNotNil(constraints)
        XCTAssertEqual(constraints.count, 0)
    }
    
    func testItCanBeInstantiatedWithAPredefinedArrayOfConstraints() {
        
        let predicate = MockPredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error: MockError.Invalid);
        
        let constraints = AsyncConstraintSet<Int>(constraints: [constraint])
        XCTAssertNotNil(constraints)
        XCTAssertEqual(constraints.count, 1)
    }
    
    func testItCanBeInstantiatedWithAUndefinedNumberOfConstraints() {
        
        let predicate = MockPredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error: MockError.Invalid);
        
        let constraints = AsyncConstraintSet<Int>(constraints: constraint)
        XCTAssertNotNil(constraints)
        XCTAssertEqual(constraints.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanAddAnAsynConstraint() {
        
        let predicate = MockPredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error: MockError.Invalid);
        
        constraints.add(constraint: constraint)
        
        XCTAssertEqual(constraints.count, 1)
    }
    
    func testItCanAddMultipleAsyncConstraints() {
        
        let aPredicate = MockPredicate<Int>()
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        let bPredicate = MockPredicate<Int>()
        let bConstraint = AsyncConstraint(predicate: bPredicate, error: MockError.Invalid);
        
        
        constraints.add(constraint: aConstraint)
        constraints.add(constraint: bConstraint)
        
        XCTAssertEqual(constraints.count, 2)
    }
    
    func testItCanAddAConstraintUsingAlternativeMethod() {
        
        let predicate = MockPredicate<Int>()
        constraints.add(predicate: predicate, error:MockError.Invalid)
        
        XCTAssertEqual(constraints.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanEvaluateAny_ForOneConstraint() {
        var aPredicate = MockPredicate<Int>()
        aPredicate.expectedResult = 10
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        constraints.add(constraint: aConstraint)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 1) { result in
            expect.fulfill()
            switch result {
            case .invalid(_): XCTAssert(true)
            default: XCTFail()
            }
        }
        waitForExpectations(timeout: 0.4, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint() {
        var aPredicate = MockPredicate<Int>()
        aPredicate.expectedResult = 10
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        var bPredicate = MockPredicate<Int>()
        bPredicate.expectedResult = 20
        let bConstraint = AsyncConstraint(predicate: bPredicate, error: MockError.Invalid);
        
        constraints.add(constraint: aConstraint)
        constraints.add(constraint: bConstraint)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 1) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 0.4, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint2() {
        var aPredicate = MockPredicate<Int>()
        aPredicate.expectedResult = 10
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        var bPredicate = MockPredicate<Int>()
        bPredicate.expectedResult = 20
        let bConstraint = AsyncConstraint(predicate: bPredicate, error: MockError.Invalid);
        
        constraints.add(constraint: aConstraint)
        constraints.add(constraint: bConstraint)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 0.4, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint3() {
        var aPredicate = MockPredicate<Int>()
        aPredicate.expectedResult = 20
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        var bPredicate = MockPredicate<Int>()
        bPredicate.expectedResult = 20
        let bConstraint = AsyncConstraint(predicate: bPredicate, error: MockError.Invalid);
        
        constraints.add(constraint: aConstraint)
        constraints.add(constraint: bConstraint)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isValid)
        }
        waitForExpectations(timeout: 0.4, handler: nil)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanEvaluateAll() {
        var aPredicate = MockPredicate<Int>()
        aPredicate.expectedResult = 20
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        var bPredicate = MockPredicate<Int>()
        bPredicate.expectedResult = 10
        let bConstraint = AsyncConstraint(predicate: bPredicate, error: MockError.Invalid);
        
        constraints.add(constraint: aConstraint)
        constraints.add(constraint: bConstraint)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAll(input: 20) { result in
            expect.fulfill()
            XCTAssertEqual([EvaluationResult.valid, EvaluationResult.invalid( MockError.Invalid)], result)
        }
        waitForExpectations(timeout: 0.4, handler: nil)
    }
    
    func testItCanEvaluateAll2() {
        var aPredicate = MockPredicate<Int>()
        aPredicate.expectedResult = 20
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        var bPredicate = MockPredicate<Int>()
        bPredicate.expectedResult = 20
        let bConstraint = AsyncConstraint(predicate: bPredicate, error: MockError.Invalid);
        
        constraints.add(constraint: aConstraint)
        constraints.add(constraint: bConstraint)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAll(input: 20) { result in
            expect.fulfill()
            XCTAssertEqual([EvaluationResult.valid, EvaluationResult.valid], result)
        }
        waitForExpectations(timeout: 0.4, handler: nil)
    }
    
    
    func testItCanEvaluateAnyWithOneCondition() {
        
        var aPredicate = MockPredicate<Int>()
        aPredicate.expectedResult = 20
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        var bPredicate = MockPredicate<Int>()
        bPredicate.expectedResult = 20
        let bCondition = AsyncConstraint(predicate: bPredicate, error: MockError.FailedCondition);
        
        constraints.add(constraint: aConstraint)
        constraints.conditions = [bCondition]
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 10) { result in
            expect.fulfill()
            XCTAssertEqual(result.error?.localizedDescription, MockError.FailedCondition.localizedDescription)
        }
        waitForExpectations(timeout: 0.4, handler: nil)
    }
    
    func testItCanEvaluateAllWithOneCondition() {
        
        var aPredicate = MockPredicate<Int>()
        aPredicate.expectedResult = 20
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: MockError.Invalid);
        
        var bPredicate = MockPredicate<Int>()
        bPredicate.expectedResult = 20
        let bCondition = AsyncConstraint(predicate: bPredicate, error: MockError.FailedCondition);
        
        constraints.add(constraint: aConstraint)
        constraints.conditions = [bCondition]
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAll(input: 10) { result in
            expect.fulfill()
            let errors = result.flatMap{$0.error?.localizedDescription}
            XCTAssertEqual(errors, [MockError.FailedCondition.localizedDescription])
        }
        waitForExpectations(timeout: 0.4, handler: nil)
    }
}

extension AsyncConstraintSetTests {
    
    enum MockError:Error {
        case Invalid
        case FailedCondition
    }
    
    struct MockPredicate<T:Equatable>:AsyncPredicate {
        
        var expectedResult:T?
        
        func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (Bool) -> Void) {
            
            queue.async {
                completionHandler(self.expectedResult == input)
            }
            
        }
    }
}
