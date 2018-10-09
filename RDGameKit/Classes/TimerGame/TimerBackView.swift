//
//  TimerBackView.swift
//  GameSample
//
//  Created by Max Ma on 5/10/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

@IBDesignable
class TimerBackView: UIView{
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        
        didSet{
            
            self.layer.borderWidth = borderWidth
        }
    }
    
    
//    @IBInspectable var borderColor: UIColor = UIColor.clear {
//        
//        didSet {
//            
//            self.layer.borderColor = borderColor.cgColor
//        }
//    }
    
    override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
    }
    
}
