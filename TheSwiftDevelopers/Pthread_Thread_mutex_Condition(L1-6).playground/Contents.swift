import UIKit

// UNIX - POSIX

func Unix() {
    var thread = pthread_t(bitPattern: 0)
    var attribute = pthread_attr_t()
    pthread_attr_init(&attribute)
    print("1")
    pthread_create(&thread, &attribute, { UnsafeMutableRawPointer in
        print("2")
        return nil
    }, nil)
     
    print("3")
}

//Unix()

// 2 Thread

func Thread() {
    var nsthread = Thread {
        print("4")
    }

    nsthread.start()

    print("5")
}

//Thread()


// Quality of service

func QualityOfServicePthreat() {
    var pthread = pthread_t(bitPattern: 0)
    var attribute = pthread_attr_t()
    pthread_attr_init(&attribute)
    pthread_attr_set_qos_class_np(&attribute, QOS_CLASS_BACKGROUND, 0)
    pthread_create(&pthread, &attribute, { UnsafeMutableRawPointer in
        print(6)
        return nil
    }, nil)

}

//QualityOfServicePthreat()

func QualityOfServiceNsthreat() {
    
    let nsthread = Thread {
        print(7)
        print(qos_class_self())
    }
    nsthread.qualityOfService = .userInteractive
    nsthread.start()
}

//QualityOfServiceNsthreat()


// Condition


var condition = pthread_cond_t()
var mutex = pthread_mutex_t()
var available = false

class ConditionMutexPrinter: Thread {
    
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        printerMethod()
    }
    
    private func printerMethod() {
        pthread_mutex_lock(&mutex)
        print("printer enter")
        while !available {
            pthread_cond_wait(&condition, &mutex)
        }
        available = false
        
        do {
            pthread_mutex_unlock(&mutex)
        }
        
        print("printer exit")
    }
}

class ConditionMutexWriter: Thread {
    
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        writerMethod()
    }
    
    private func writerMethod() {
        pthread_mutex_lock(&mutex)
        print("writer enter")
        
        available = true
        pthread_cond_signal(&condition)
        
        do {
            pthread_mutex_unlock(&mutex)
        }
        
        print("writer exit")
    }
}

//let printer = ConditionMutexPrinter()
//let writer = ConditionMutexWriter()
//print(1)
//printer.start()
//print(2)
//writer.start()
//print(3)
//
//
let cond = NSCondition()
var availables = false

class WriterThread: Thread {
    override func main() {
        cond.lock()
        print("Writer enter")
        availables = true
        cond.signal()
        cond.unlock()
        print("Writer end")
    }
}

class PrinterThread: Thread {
    
    override func main() {
        cond.lock()
        print("Printer enter")
        while !availables {
            print("LUL")
            cond.wait()
            print("KEK")
        }
        
        cond.unlock()
        print("printer enter")
    }
}


//let writerr: WriterThread = WriterThread()
//let printerr: PrinterThread = PrinterThread()
//
//printerr.start()
//writerr.start()
