//
//  RacingGameVC.swift
//  RDGameKit_Example
//
//  Created by Max Ma on 15/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RDGameKit

class RacingGameVC: UIViewController {

    @IBOutlet weak var racingGameContainer: RacingGameContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.racingGameContainer.configUI(description: "Race Usain Bolts record breaking time to win.\n\nThe top 5 fastest at the end of month will win a $100 gift voucher.", boltTime: TimeInterval(9.5), steps: 10)
        self.racingGameContainer.delegate = self
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
extension RacingGameVC: RacingGameContainerDelegate {
    func entryButtonClicked(playerTime: TimeInterval, boltTime: TimeInterval) {
        print("playerTime: \(playerTime) boltTime: \(boltTime)")
    }
    
    
}
