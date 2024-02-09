import UIKit
// https://habr.com/ru/articles/578752/

let serialQueue = DispatchQueue(label: "ru.denisegaluev.serial-queue")
let concurrentQueue = DispatchQueue(label: "ru.denisegaluev.concurrent-queue", attributes: .concurrent)

let globalQueue = DispatchQueue.global(qos: .background)
let mainQueue = DispatchQueue.main

func printNumber(number: Int) {
    for _ in 1...1 {
        print(number, Thread.current)
    }

}

func exampleSync() {
    printNumber(number: 1)
    printNumber(number: 2)
    printNumber(number: 3)
    printNumber(number: 4)
    serialQueue.sync {
        printNumber(number: 5)
    }
    printNumber(number: 6)
}


func exampleAsync() {
    printNumber(number: 1)
    printNumber(number: 2)
    printNumber(number: 3)
    printNumber(number: 4)
    serialQueue.async {
        printNumber(number: 5)
    }
    printNumber(number: 6)
}

func examplecommon1() {
    printNumber(number: 1)
    printNumber(number: 2)
    serialQueue.async {printNumber(number: 3)}
    printNumber(number: 4)
    serialQueue.async {printNumber(number: 5)}
    printNumber(number: 6)
    serialQueue.sync { printNumber(number: 7) }
    printNumber(number: 8)
    printNumber(number: 9)

}


func examplecommon2() {
    printNumber(number: 1)
    printNumber(number: 2)
    concurrentQueue.async {printNumber(number: 3)}
    printNumber(number: 4)
    concurrentQueue.sync {printNumber(number: 5)}
    printNumber(number: 6)
    concurrentQueue.sync {
        printNumber(number: 7)
    }
    
    printNumber(number: 8)
    printNumber(number: 9)
    
    

}


func exampleSubQueue() {
    concurrentQueue.async {
        printNumber(number: 1)
        
        serialQueue.async{ printNumber(number: 2) }
    }

    concurrentQueue.sync {
        serialQueue.async{ printNumber(number: 3) }
        
        serialQueue.async{ printNumber(number: 4) }
        
        serialQueue.async{ printNumber(number: 5) }
    }

    printNumber(number: 6)

    serialQueue.async {
        concurrentQueue.sync{printNumber(number: 7) }
    }

    printNumber(number: 8)

}
// 1 6 7 8 2 3 4 5
//exampleSubQueue()

// MARK: Async After

func asyncAfterExample() {
    print(1)
    serialQueue.asyncAfter(deadline: .now() + 1) {
        print(2)
    }
    print(3)
}
//asyncAfterExample()

// MARK: Dispatch work item
// notify
func dispatchWorkItemExample1() {
    let dispatchItem = DispatchWorkItem {
        print("WorkItem run")
    }
    
    dispatchItem.notify(queue: DispatchQueue.main) {
        print("WorkItem done")
    }
    
    serialQueue.sync(execute: dispatchItem)
}

//dispatchWorkItemExample1()
// notify without workitem
func dispatchWorkItemExample2() {
    serialQueue.async {
        print(1)
        
        DispatchQueue.main.async {
            print(2)
        }
        
        print(3)
    }
}
//dispatchWorkItemExample2()

//cancel
func dispatchWorkItemExample3() {
    let workItem = DispatchWorkItem {
        print("DispatchWorkItem task")
    }

    // Усыпляем serialQueue на 1 секунду и сразу возвращаем управление
    serialQueue.async {
        print("zzzZZZZ")
        sleep(1)
        print("Awaked")
    }

    // Ставим workItem в очередь serialQueue и сразу возвращаем управление
    serialQueue.async(execute: workItem)

    // Отменяем workItem
    workItem.cancel()
}
//dispatchWorkItemExample3()


// MARK: Semaphore


func semaphoreExample1() {
    let semaphore = DispatchSemaphore(value: 0)

    // Усыпляем serialQueue на 5 секунд, после вызываем метод signal тем самым
    serialQueue.async {
        print(1)
        sleep(5)
        print(2)
        // Разблокировавыем семафор
        semaphore.signal()
        
    }

    // Блокируем очередь
    semaphore.wait()
}
//semaphoreExample1()

// MARK: DispatchGroup

func dispatchGroupExample1() {
    let dispatchGroup = DispatchGroup()
    
    let workItem1 = DispatchWorkItem {
        print(1)
        sleep(1)
        print(2)
    }
    
    let workItem2 = DispatchWorkItem {
        print(3)
        sleep(1)
        print(4)
    }
    
    serialQueue.async(group: dispatchGroup, execute: workItem1)
    serialQueue.async(group: dispatchGroup, execute: workItem2)
    
    dispatchGroup.notify(queue: DispatchQueue.main) {
        print("Group tasks done")
    }
}


//dispatchGroupExample1()
func dispatchGroupExample2() {
    // Создаем параллельную очередь
    let concurrentQueue = DispatchQueue(label: "ru.denisegaluev.concurrent-queue", attributes: .concurrent)

    // Создаем группу
    let group = DispatchGroup()

    // Создаем DispatchWorkItem
    let workItem1 = DispatchWorkItem {
        print("workItem1: zzzZZZ")
        sleep(3)
        print("workItem1: awaked")
        
        // Покидаем группу
        group.leave()
    }

    let workItem2 = DispatchWorkItem {
        print("workItem2: zzzZZZ")
        sleep(3)
        print("workItem2: awaked")
        
        group.leave()
    }

    // Входим в группу
    group.enter()
    // Вызы
    concurrentQueue.async(execute: workItem1)

    group.enter()
    concurrentQueue.async(execute: workItem2)

    // Ожидаем, пока все задачи в группе закончат свое выполнение
    group.wait()
    print("All tasks on group completed")
}


//dispatchGroupExample2()


// MARK: Dispatch barrier

// Dispatch Barries - механизм синхронизации задач в очереди

class DispatchBarrierTesting {
    // Создаем параллельную очередь
    private let concurrentQueue = DispatchQueue(label: "ru.denisegaluev.concurrent-queue", attributes: .concurrent)
    
    // Создаем переменную _value для внутреннего использования
    private var _value: String = "2"
    
    // Создаем thread safe переменную value для внешнего использования
    var value: String {
        get {
            var tmp: String = ""
            
            concurrentQueue.sync {
                tmp = _value
            }
            
            return tmp
        }
        
        set {
            concurrentQueue.async(flags: .barrier) {
                self._value = newValue
            }
        }
    }
}


let test = DispatchBarrierTesting()



// MARK: Race Condition
func raceCondition() {
    // 1
    var value: Int = 0

    // 2
    func increment() { value += 1 }

    // 3
    serialQueue.async {
        // 4
        sleep(5)
        increment()
    }

    // 5
    print(value)

    // 6
    value = 10

    // 7
    serialQueue.sync {
        increment()
    }
    // 8
    print(value)
}



// Решение сделать [3] sync ( ну это очевидно )

// MARK: Deadlock

print("Start")

serialQueue.sync {
    print("HERE")
    serialQueue.sync {
        print("Deadlock")
    }
}

print("Finish")
