import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "Que", attributes: .concurrent)

//let semaphore = DispatchSemaphore(value: 0)
//
//queue.async {
//    semaphore.wait() // -1
//    sleep(3)
//    print("Method 1")
//    semaphore.signal()
//}
//
//queue.async {
//    semaphore.wait() // -1
//    sleep(3)
//    print("Method 2")
//    semaphore.signal()
//}
//
//queue.async {
//    semaphore.wait() // -1
//    sleep(3)
//    print("Method 3")
//    semaphore.signal()
//}

//let sem = DispatchSemaphore(value: 0)
//
//DispatchQueue.concurrentPerform(iterations: 10) { id in
//    sem.wait(timeout: .distantFuture)
//    sleep(1)
//    print("Block", id)
//    
//    sem.signal()
//}

DispatchQueue.global().async {
    for i in 1...200000 {
        print(i, Thread.current)
    }
}

class SemaphoreTest {
    private let semaphore = DispatchSemaphore(value: 0)
    
    var array = [Int]()
    
    func methoWork(_ id: Int) {
        semaphore.wait()
        array.append(id)
        print(array)
        sleep(2)
        semaphore.signal()
    }
    
    func startAll() {
        DispatchQueue.global().async {
            self.methoWork(1111)
            print(Thread.current)
        }
        
        DispatchQueue.global().async {
            self.methoWork(23)
            print(Thread.current)
        }
        
        DispatchQueue.global().async {
            self.methoWork(24)
            print(Thread.current)
        }
        
        DispatchQueue.global().async {
            self.methoWork(555)
            print(Thread.current)
        }
    }
}

let semaphoreTest = SemaphoreTest()
semaphoreTest.startAll()
print("ALO")
