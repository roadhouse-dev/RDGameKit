//
//  TicTacToeVC.swift
//  RDGameKit_Example
//
//  Created by Max Ma on 20/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RDGameKit

class TicTacToeVC: UIViewController {
    
    @IBOutlet weak var ticTacToeContainer: TicTacToeContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gameBoardSettings = GameBoardSettings()
        gameBoardSettings.outerBorderWidth = 8
        ticTacToeContainer.ticTacToeContainerDelegate = self
        ticTacToeContainer.setUp(backgroundImage: #imageLiteral(resourceName: "background-blue"), gameBoardSettings: gameBoardSettings)
        // Do any additional setup after loading the view.
    }

}

extension TicTacToeVC: TicTacToeContainerDelegate {
    func getResult(result: (Int, Int, Int)) {
        print("Result: \(result)")
    }
}
