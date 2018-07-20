//
//  SpinWheelSlice.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 19/7/18.
//

import Foundation
import UIKit

public class SpinWheelSlice: SpinWheelSliceProtocol {
    public var backgroundColor: UIColor?
    public var title: String
    public var icon: UIImage
    public var description: String
    public var degree: CGFloat = 0.0
    
    public var fontColor: UIColor {
        return UIColor.white
    }
    
    public var offsetFromExterior:CGFloat {
        return 10.0
    }
    
    public var stroke: StrokeInfo? {
        return StrokeInfo(color: UIColor.white, width: 1.0)
    }
    
    public init(title: String, description: String, icon: UIImage, backgroundColor: UIColor) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.description = description
    }
    
    public convenience init(title: String, description: String, icon: UIImage, backgroundColor: UIColor, degree:CGFloat) {
        self.init(title: title, description: description, icon: icon, backgroundColor: backgroundColor)
        self.degree = degree
    }
    
}
