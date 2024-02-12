import UIKit

let que = OperationQueue()

//class OperationCancelTest: Operation {
//    override func main() {
//        if isCancelled {
//            print(isCancelled)
//            return
//        }
//        print("No cancel")
//        sleep(1)
//        
//        if isCancelled {
//            print(isCancelled)
//            return
//        }
//        
//        print("No cancel 2")
//    }
//}
//
//func cancelMethod() {
//    let op = OperationCancelTest()
//    que.addOperation(op)
//    
//    op.cancel()
//}
//cancelMethod()


class WaitOperationTest {
    private let operationQueue = OperationQueue()
    
    func test() {

        operationQueue.addOperation {
            sleep(1)
            print("test1")
        }
        
        operationQueue.addOperation {
            sleep(2)
            print("test2")
        }
        
        operationQueue.waitUntilAllOperationsAreFinished()
        
        operationQueue.addOperation {
            print("test3")
        }
        
        operationQueue.addOperation {
            print("test4")
        }
    }
}


let waitOpTest = WaitOperationTest()
//waitOpTest.test()

class WaitOperationTest2 {
    private let operationQueue = OperationQueue()
    
    
    func test() {
        let operation1 = BlockOperation {
            sleep(1)
            print("test 1")
        }
        
        operation1.addExecutionBlock {
            print("?")
        }
        
        let operation2 = BlockOperation {
            sleep(2)
            print("test 2")
        }
        
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: false)
        
        print("Hi")
    }
    
}
let waitOpTest2 = WaitOperationTest2()

waitOpTest2.test()

class CompletionBlockTest {
    private let operationQueue = OperationQueue()
    
    func test() {
        let operation1 = BlockOperation {
            sleep(1)
            print("test 1")
        }
        operation1.completionBlock = {
            print("FINISH")
        }
        operationQueue.addOperation(operation1)

        
    }
}

let a = CompletionBlockTest()
a.test()
