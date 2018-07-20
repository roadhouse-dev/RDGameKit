//
//  ScratchCard.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 17/7/18.
//

import UIKit

@objc public protocol ScratchCardDelegate {
    @objc optional func scratchBegan(point: CGPoint)
    @objc optional func scratchMoved(progress: Float)
    @objc optional func scratchEnded(point: CGPoint)
}

public class ScratchCard: UIView {
    
    var scratchMask: ScratchMask!
    var couponImageView: UIImageView!
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
    }
    
    open var delegate: ScratchCardDelegate?
        {
        didSet
        {
            scratchMask.delegate = delegate
        }
    }
    
    public func createScratchView(couponImage: UIImage, maskImage: UIImage,
                                  scratchWidth: CGFloat = 15, scratchType: CGLineCap = .square) {
        let childFrame = CGRect(x: 0, y: 0, width: self.frame.width,
                                height: self.frame.height)
        //add image
        couponImageView = UIImageView(frame: childFrame)
        couponImageView.image = couponImage
        couponImageView.contentMode = .scaleAspectFill
        couponImageView.layer.cornerRadius = self.cornerRadius
        self.addSubview(couponImageView)
        
        //add scratchMask
        scratchMask = ScratchMask(frame: childFrame)
        scratchMask.image = maskImage
        scratchMask.contentMode = .scaleAspectFill
        scratchMask.lineWidth = scratchWidth
        scratchMask.lineType = scratchType
        scratchMask.layer.cornerRadius = self.cornerRadius
        
        self.addSubview(scratchMask)
    }
}
