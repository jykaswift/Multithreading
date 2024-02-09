import UIKit
import Foundation
// https://habr.com/ru/articles/572316/

// MARK: Pthread


var pthread = pthread_t(bitPattern: 0)
var attribute = pthread_attr_t()
pthread_attr_init(&attribute)

pthread_create(&pthread, &attribute, { _ in
    print("Hello world")
    return nil
}, nil)

// MARK: Thread

let thread = Thread {
    print("Hello world!")
}

thread.start()

// MARK: Quality of service
//QOS_CLASS_USER_INTERACTIVE - используется для задач, связанных со взаимодействием с пользователем, таких как анимации, обработка событий, обновление интерфейса.
//QOS_CLASS_USER_INITIATED - используется для задач, которые требуют немедленного фидбека, но не связанных с интерактивными UI событиями.
//QOS_CLASS_DEFAULT - используется для задач, которые по умолчанию имеют более низкий приоритет, чем user interactive и user initiated задачи, но более высокий приоритет, чем utility и background задачи. QOS_CLASS_DEFAULT является QOS по умолчанию.
//QOS_CLASS_UTILITY - используется для задач, в которых не требуется получить немедленный результат, например запрос в сеть. Наиболее сбалансированный QOS с точки зрения потребления ресурсов.
//QOS_CLASS_BACKGROUND - имеет самый низкий приоритет и используется для задач, которые не видны пользователю, например синхронизация или очистка данных.
//QOS_CLASS_UNSPECIFIED - используется только в том случае, если мы работаем со старым API, который не поддерживает QOS


var qosPthread = pthread_t(bitPattern: 0)
var qosAttribute = pthread_attr_t()
pthread_attr_init(&qosAttribute)
pthread_attr_set_qos_class_np(&qosAttribute, QOS_CLASS_BACKGROUND, 0)

pthread_create(
    &qosPthread,
    &qosAttribute,
    { _ in
        print("Hello world!!")
        // Переключаем QOS в ходе выполнения операции
        pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0)
        return nil
    },
    nil)


var qosThread = Thread {
    print("Hello world!!!")
}

qosThread.qualityOfService = .userInitiated
qosThread.start()

// MARK: Mutex - безопасный доступ нескольких потоков к ресурсу

var mutex = pthread_mutex_t()
pthread_mutex_init(&mutex, nil)
var resource = 0
func appendResource() {
    // Захватываем ресурс
    pthread_mutex_lock(&mutex)
    // Выполняем работу
    resource += 1
    // Освобождаем ресурс
    pthread_mutex_unlock(&mutex)
}

func readResource() {
    pthread_mutex_lock(&mutex)
    print(resource)
    pthread_mutex_unlock(&mutex)
}
for i in 0...10 {
    
    if i % 2 == 0 {
        pthread_create(
            &qosPthread,
            &qosAttribute,
            { _ in
                appendResource()
                return nil
            },
            nil)
    } else {
        pthread_create(
            &qosPthread,
            &qosAttribute,
            { _ in
                readResource()
                return nil
            },
            nil)
    }
    
}

sleep(1)

print(resource)

var sharedVariable = 0

func threadFunction() {
    pthread_mutex_lock(&mutex)
    for _ in 1...1000 {
        let temp = sharedVariable
        sharedVariable = temp + 1
    }
    pthread_mutex_unlock(&mutex)
}

// Создаем два потока
let thread1 = Thread { threadFunction() }
let thread2 = Thread { threadFunction() }

// Запускаем потоки
thread1.start()
thread2.start()

sleep(1)
print("Final value of sharedVariable: \(sharedVariable)")


// MARK: NSLock

var sharedValueNSLock = 0
var nsLock = NSLock()
func threadFunctionNSLock() {
    nsLock.lock()
    for _ in 1...1000 {
        let temp = sharedValueNSLock
        sharedValueNSLock = temp + 1
    }
    nsLock.unlock()
}

// Создаем два потока
let thread3 = Thread { threadFunctionNSLock() }
let thread4 = Thread { threadFunctionNSLock() }

// Запускаем потоки
thread3.start()
thread4.start()

sleep(1)
print("Final value of sharedVariable: \(sharedValueNSLock)")


// MARK: NSCondition

let condition = NSCondition()
var isWriting = true

func read() {
    condition.lock()
    print("Read enter")
    while isWriting {
        condition.wait() // Mutex неявно освобождается при входе в состояние ожидания
    }
    print("Read end")
    
    condition.unlock()
}

func write() {
    condition.lock()
    isWriting = false
    condition.signal()
    print("write end")
    condition.unlock()
}

let threadRead = Thread {
    read()
}

let threadWrite = Thread {
    write()
}

threadRead.start()
threadWrite.start()
