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
        self.timerPageContainer.configUI(backgroundImage: #imageLiteral(resourceName: "background"), description: "Match Usain Bolts record breaking time to go onto the leaderboard.\n\nThe top 5 closest times at the end of the month will win a $ 100 gift voucher.", targetMs: 12000)
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
    func getResult(result: Double) {
        print("result: \(result)")
    }
}
