//
//  TimerGameVC.swift
//  RDGameKit_Example
//
//  Created by Max Ma on 9/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RDGameKit

class TimerGameVC: UIViewController {
    @IBOutlet weak var enterBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerPageContainer: TimerPageContainer!
    
   // @IBOutlet weak var timerGameContainer: TimerGameContainer!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        
        self.timerPageContainer.configUI(backgroundImage: #imageLiteral(resourceName: "background"), description: "Tap the button to start the timer, then tap it  again to get as close to Usain's superhuman record as you can.", targetMs: 12000)
        
        
        self.timerPageContainer.delegate = self
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

extension TimerGameVC: TimerGameContainerDelegate {
    func getError(result: String) {
        print("get error : \(result)")
    }
    
    func getResult(result: Double) {
        print("result: \(result)")
    }
}
