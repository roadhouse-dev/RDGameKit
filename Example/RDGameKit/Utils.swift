//
//  Utils.swift
//  RoadhouseGameKit_Example
//
//  Created by Max Ma on 19/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class Utils {
    public class func uiColor(from rgbValue: UInt, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
