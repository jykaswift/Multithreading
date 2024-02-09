import UIKit
import PlaygroundSupport




class VC: UIViewController {
    private lazy var button = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.setTitle("Tap me", for: .normal)
        button.backgroundColor = .blue
        let action = UIAction { _ in
            let vc2 = VC2()
            self.navigationController?.pushViewController(vc2, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "VC 1"
        button.center = view.center
        view.addSubview(button)
    }
}


class VC2: UIViewController {
    
    private lazy var image = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "VC 2"
        setup()
        let imageURL = URL(string: "https://i.natgeofe.com/n/548467d8-c5f1-4551-9f58-6817a8d2c45e/NationalGeographic_2572187_square.jpg")!
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
                
            }
        }
       
    }
    
    func setup() {
        image.center = view.center
        view.addSubview(image )
    }
}

let vc = VC()
let navbar = UINavigationController(rootViewController: vc)
navbar.view.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
PlaygroundPage.current.liveView = navbar
