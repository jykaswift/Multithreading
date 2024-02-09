//
//  SecondVCViewController.swift
//  AsyncAfter_ConcurrentPerform_InitiallyInactive(L9)
//
//  Created by Евгений Борисов on 08.02.2024.
//

import UIKit

class SecondVCViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myInactiveQueue()
       
    }
    
    func myInactiveQueue() {
        let inactiveQueue = DispatchQueue(label: "df", attributes: [.concurrent, .initiallyInactive])
        
        inactiveQueue.async {
            print("Done!")
        }
        
        print("Not yet started...")
        
        inactiveQueue.activate()
        print("ACTIVATE!")
        inactiveQueue.suspend()
        print("Pause")
        inactiveQueue.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
