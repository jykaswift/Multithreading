import UIKit

import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//
////class DispatchWorkItem1 {
////    private let que = DispatchQueue(label: "WorkItem1", attributes: .concurrent)
////    
////    func create() {
////        let workItem = DispatchWorkItem {
////            print("BLOCK")
////            print(Thread.current)
////        }
////        
////        workItem.notify(queue: .main) {
////            print("MAIN after workitem")
////            print(Thread.current )
////        }
////        
////        que.async(execute: workItem)
////    }
////    
////}
////
////class DispatchWorkItem2 {
////    private let que = DispatchQueue(label: "WorkItem2")
////    
////    func create() {
////        que.async {
////            sleep(1)
////            print(Thread.current)
////            print("Task1")
////        }
////        
////        que.async {
////            sleep(1)
////            print(Thread.current)
////            print("task2")
////        }
////        
////        let workItem = DispatchWorkItem {
////            print(Thread.current)
////            print("Work item")
////        }
////        
////        que.async(execute: workItem)
////        workItem.cancel()
////    }
////    
////}
////
//////let workitem1 = DispatchWorkItem1()
//////let workitem2 = DispatchWorkItem2()
//////
//////workitem2.create()
////
////
//
//
//var view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//imageView.backgroundColor = .yellow
//imageView.contentMode = .scaleAspectFit
//view.addSubview(imageView)
//
//PlaygroundPage.current.liveView = view
//
//let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Cat_August_2010-4.jpg/1200px-Cat_August_2010-4.jpg")!
//
//// fetch image
//
//func fetchImage() {
//    let que = DispatchQueue.global(qos: .utility)
//    
//    que.async {
//        if let data = try? Data(contentsOf: imageURL) {
//            DispatchQueue.main.async {
//                imageView.image = UIImage(data: data)
//            }
//        }
//    }
//   
//
//}
////fetchImage()
//
//func fetchImage2() {
//    var data: Data?
//    
//    let que = DispatchQueue.global(qos: .utility)
//    
//    let workItem = DispatchWorkItem(qos: .userInteractive) {
//        data = try? Data(contentsOf: imageURL)
//    }
//    
//    que.async(execute: workItem)
//    
//    workItem.notify(queue: .main) {
//        if let data {
//            imageView.image = UIImage(data: data)
//        }
//    }
//}
//
//fetchImage2()
//
//// URL Session
//
//func fetchImage3() {
//    let urlSession = URLSession.shared.dataTask(with: imageURL) { data, response, error in
//        print(response)
//        if let data {
//            DispatchQueue.main.async {
//                imageView.image = UIImage(data: data)
//            }
//        }
//    }
//    urlSession.resume()
//}
//
//fetchImage3()

let queue = DispatchQueue(label: "queue", attributes: .concurrent)
let workItem = DispatchWorkItem {
    sleep(3)
    print("done")
}
    
queue.async(execute: workItem)
print("before waiting")
workItem.wait()
print("after waiting")
