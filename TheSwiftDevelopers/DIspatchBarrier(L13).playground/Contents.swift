 import UIKit

var greeting = "Hello, playground"


class SafeArray<T> {
    private var array = [T]()
    
    private var queue = DispatchQueue(label: "Something", attributes: .concurrent)
    
    public func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }
    
    public var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }
}
    
var arraySafe = SafeArray<Int>()

DispatchQueue.concurrentPerform(iterations: 10) { index in
    arraySafe.append(index)
}
print(arraySafe.valueArray)
