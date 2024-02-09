//
//  ViewController.swift
//  AsyncAfter_ConcurrentPerform_InitiallyInactive(L9)
//
//  Created by Евгений Борисов on 08.02.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Test alert", message: "Test?", preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default) { _ in
            print("Hello")
        }
        alert.addAction(button)
        self.present(alert, animated: true)
    }
    
    func afterBlock(second: Int, queue: DispatchQueue = DispatchQueue.global(), compilition: @escaping () -> ()) {
        queue.asyncAfter(deadline: .now() + .seconds(second)) {
            compilition()
        }
    }

}

