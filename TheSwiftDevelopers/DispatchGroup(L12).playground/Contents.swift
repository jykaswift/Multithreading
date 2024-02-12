import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//class DispatchGroupTest {
//    let serialQueue = DispatchQueue(label: "Group")
//
//    private let groupRed = DispatchGroup()
//    
//    
//    func loadInfo() {
//        serialQueue.async(group: groupRed) {
//            sleep(1)
//            print("1")
//        }
//        
//        serialQueue.async(group: groupRed) {
//            sleep(1)
//            print("2")
//        }
//        
//        groupRed.notify(queue: .main) {
//            print("finish")
//        }
//    }
//    
//}
//
//let dispatchGroup = DispatchGroupTest()
//dispatchGroup.loadInfo()

class DispatchGroupTest {
    let cuncurrentQueue = DispatchQueue(label: "Group", attributes: .concurrent)

    private let groupRed = DispatchGroup()
    
    
    func loadInfo() {
        groupRed.enter()
        cuncurrentQueue.async {
            sleep(1)
            print("1")
            self.groupRed.leave()
        }

        groupRed.enter()
        cuncurrentQueue.async {
            sleep(1)
            print("2")
            self.groupRed.leave()
        }
        
        groupRed.wait()
        print("FINISH")
    }
    
}
let dispatchGroup = DispatchGroupTest()
dispatchGroup.loadInfo()


class MainView: UIView {
    public var imageArray = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageArray.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        imageArray.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
        imageArray.append(UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100)))
        imageArray.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        
        imageArray.append(UIImageView(frame: CGRect(x: 0, y: 300, width: 100, height: 100)))
        imageArray.append(UIImageView(frame: CGRect(x: 100, y: 300, width: 100, height: 100)))
        imageArray.append(UIImageView(frame: CGRect(x: 0, y: 400, width: 100, height: 100)))
        imageArray.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100)))
        
        for image in imageArray {
            image.contentMode = .scaleAspectFit
            addSubview(image)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


var view = MainView(frame: CGRect(x: 0, y: 0, width: 500, height: 900))
view.backgroundColor = .red
let urls = [
    "https://img.freepik.com/free-photo/adorable-looking-kitten-with-yarn_23-2150886292.jpg",
    "https://img.freepik.com/free-photo/beautiful-kitten-with-colorful-clouds_23-2150752964.jpg",
    "https://img.freepik.com/free-photo/close-up-on-adorable-kitten-indoors_23-2150782423.jpg",
    "https://cs11.pikabu.ru/post_img/2019/02/04/12/1549312329147951618.jpg"
]

var images = [UIImage]()

PlaygroundPage.current.liveView = view

func loadImages(
    imageUrl: URL,
    runQueue: DispatchQueue,
    completionQueue: DispatchQueue,
    completion: @escaping (UIImage?, Error?) -> ()
) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageUrl)
            completionQueue.async {
                completion(UIImage(data: data), nil)
            }
        } catch let error {
            completionQueue.async {
                completion(nil, error)
            }
        }
    }
    
}

func asyncGroupLoad() {
    let group = DispatchGroup()
    
    for i in 0...3 {
        group.enter()
        loadImages(
            imageUrl: URL(string: urls[i])!,
            runQueue: .global(),
            completionQueue: .main) { image, error in
                guard let image else {
                    return
                }
                images.append(image)
                group.leave()
            }
    }
    
    group.notify(queue: .main) {
        for i in urls.indices {
            view.imageArray[i].image = images[i]
        }
    }
}

func loadURLSession() {
    for i in 4...7 {
        let url = URL(string: urls[i - 4])
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            sleep(1)
            DispatchQueue.main.async {
                view.imageArray[i].image = UIImage(data: data!)
            }
        }
        task.resume()
        
        
    }
}

loadURLSession()
