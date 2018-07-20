//
//  SpinWheelVC.swift
//  RDGameKit_Example
//
//  Created by Max Ma on 19/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RDGameKit

class SpinWheelVC: UIViewController {
    @IBOutlet weak var spinWheelContainer: SpinWheelContainer!
    let slices = [ SpinWheelSlice.init(title: "1 Slurpee", description: "Present this to redeem 1 Slurpee at any 7-Eleven store", icon: #imageLiteral(resourceName: "slurpee"), backgroundColor: Utils.uiColor(from:0xE27230)),
                   SpinWheelSlice.init(title: "1 Medium Coffee", description: "Present this to redeem 1 Medium Coffee at any 7-Eleven store", icon: #imageLiteral(resourceName: "coffe_cup"), backgroundColor: Utils.uiColor(from:0xF7D565)),
                   SpinWheelSlice.init(title: "1 Doughnut", description: "Present this to redeem 1 Doughnut at any 7-Eleven store", icon: #imageLiteral(resourceName: "doughnuts"),  backgroundColor: Utils.uiColor(from:0x93D0C4)),
                   SpinWheelSlice.init(title: "1 Slurpee", description: "Present this to redeem 1 Slurpee at any 7-Eleven store", icon: #imageLiteral(resourceName: "slurpee"),  backgroundColor: Utils.uiColor(from:0x2A7F7F)),
                   SpinWheelSlice.init(title: "1 Medium Coffee", description: "Present this to redeem 1 Medium Coffee at any 7-Eleven store", icon: #imageLiteral(resourceName: "coffe_cup"),  backgroundColor: Utils.uiColor(from:0xE27230)),
                   SpinWheelSlice.init(title: "1 Slurpee", description: "Present this to redeem 1 Slurpee at any 7-Eleven store", icon: #imageLiteral(resourceName: "slurpee"),  backgroundColor: Utils.uiColor(from:0xF7D565)),
                   SpinWheelSlice.init(title: "1 Doughnut", description: "Present this to redeem 1 Doughnut at any 7-Eleven store", icon: #imageLiteral(resourceName: "doughnuts"),  backgroundColor: Utils.uiColor(from:0x93D0C4)),
                   SpinWheelSlice.init(title: "$50 Gift Card", description: "Present this to redeem $50 Gift Card at any 7-Eleven store", icon: #imageLiteral(resourceName: "petrol"),  backgroundColor: Utils.uiColor(from:0x2A7F7F))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinWheelContainer.setUp(backgroundImage: #imageLiteral(resourceName: "background"), logo: #imageLiteral(resourceName: "logo"), bottomLogo: #imageLiteral(resourceName: "instructions"), spinButtonImage: #imageLiteral(resourceName: "pin"), spinBackImage: #imageLiteral(resourceName: "background"), slices: slices)
        spinWheelContainer.spinWheelContainerDelegate = self
    }

}

extension SpinWheelVC: SpinWheelContainerDelegate {
    func getPrize(slice: SpinWheelSliceProtocol) {
        print("slice: \(slice)")
    }
}
