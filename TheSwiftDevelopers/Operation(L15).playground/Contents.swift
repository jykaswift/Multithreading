import UIKit

var greeting = "Hello, playground"

//let operation1 = {
//    print("Start")
//    print(Thread.current)
//    print("Finish")
//}
//
//let queue = OperationQueue()
//
//queue.addOperation(operation1)

print(Thread.current)

var result: String?
let concatOperation = BlockOperation {
    result = "123"
    print(Thread.current)
}






let que = OperationQueue()
que.addOperation(concatOperation)
que.waitUntilAllOperationsAreFinished()
print(result!)


let queueSecond = OperationQueue()
queueSecond.addOperation {
    print("test")
    print(Thread.current)
}


class myThread: Thread {
    override func main() {
        print("TEST main thread")
        print(Thread.current)
    }
}

let MyThread: myThread = .init()
MyThread.start()

class OperationA: Operation {
    override func main() {
        print("Test operation a")
        print(Thread.current)
    }
}

let op = OperationA()

queueSecond.addOperation(op)
