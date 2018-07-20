//
//  ViewController.swift
//  RDGameKit
//
//  Created by Max Ma on 07/17/2018.
//  Copyright (c) 2018 Max Ma. All rights reserved.
//

import UIKit
import RDGameKit

class ScratchExampleVC: UIViewController {
    //@IBOutlet weak var scratchCard: ScratchCard!
    private var displayed = false
    @IBOutlet weak var scratchCardContainer: ScratchCardContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scratchCardContainer.setUp(backgroundImage: #imageLiteral(resourceName: "background-blue"), logo: #imageLiteral(resourceName: "logo-2"), bottomLogo: #imageLiteral(resourceName: "instructions-2"), couponImage: #imageLiteral(resourceName: "sports"), maskImage: #imageLiteral(resourceName: "mask_sports"))
        scratchCardContainer.setUpPrize(pizeImage: #imageLiteral(resourceName: "prize-2"))
        scratchCardContainer.scratchCardContainerDelegate = self
        //Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ScratchExampleVC: ScratchCardContainerDelegate {
    func getPrize() {
        print("getPrize")
    }
}

