//
//  SpinWheelUtils.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 19/7/18.
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
    
    //QuartzCode methods utils
    class func group(animations : [CAAnimation], fillMode : String!, forEffectLayer : Bool = false, sublayersCount : NSInteger = 0) -> CAAnimationGroup!{
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = animations
        
        if (fillMode != nil){
            if let animations = groupAnimation.animations {
                for anim in animations {
                    anim.fillMode = fillMode
                }
            }
            groupAnimation.fillMode = fillMode
            groupAnimation.isRemovedOnCompletion = false
        }
        
        if forEffectLayer{
            groupAnimation.duration = Utils.maxDuration(ofEffectAnimation: groupAnimation, sublayersCount: sublayersCount)
        }else{
            groupAnimation.duration = Utils.maxDuration(ofAnimations: animations)
        }
        
        return groupAnimation
    }
    
    class func maxDuration(ofAnimations anims: [CAAnimation]) -> CFTimeInterval{
        var maxDuration: CGFloat = 0;
        for anim in anims {
            maxDuration = max(CGFloat(anim.beginTime + anim.duration) * CGFloat(anim.repeatCount == 0 ? 1.0 : anim.repeatCount) * (anim.autoreverses ? 2.0 : 1.0), maxDuration);
        }
        
        if maxDuration.isInfinite {
            return TimeInterval(NSIntegerMax)
        }
        
        return CFTimeInterval(maxDuration);
    }
    
    class func maxDuration(ofEffectAnimation anim: CAAnimation, sublayersCount : NSInteger) -> CFTimeInterval{
        var maxDuration : CGFloat = 0
        if let groupAnim = anim as? CAAnimationGroup{
            for subAnim in groupAnim.animations! as [CAAnimation]{
                
                var delay : CGFloat = 0
                if let instDelay = (subAnim.value(forKey: "instanceDelay") as? NSNumber)?.floatValue{
                    delay = CGFloat(instDelay) * CGFloat(sublayersCount - 1);
                }
                var repeatCountDuration : CGFloat = 0;
                if subAnim.repeatCount > 1 {
                    repeatCountDuration = CGFloat(subAnim.duration) * CGFloat(subAnim.repeatCount-1);
                }
                var duration : CGFloat = 0;
                
                duration = CGFloat(subAnim.beginTime) + (subAnim.autoreverses ? CGFloat(subAnim.duration) : CGFloat(0)) + delay + CGFloat(subAnim.duration) + CGFloat(repeatCountDuration);
                maxDuration = max(duration, maxDuration);
            }
        }
        
        if maxDuration.isInfinite {
            maxDuration = 1000
        }
        
        return CFTimeInterval(maxDuration);
    }
    
    class func updateValueFromAnimations(forLayers layers: [CALayer]){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        for aLayer in layers{
            if let keys = aLayer.animationKeys() as [String]!{
                for animKey in keys{
                    let anim = aLayer.animation(forKey: animKey)
                    updateValue(forAnimation: anim!, theLayer: aLayer);
                }
            }
            
        }
        
        CATransaction.commit()
    }
    
    class func updateValue(forAnimation anim: CAAnimation, theLayer : CALayer){
        if let basicAnim = anim as? CABasicAnimation{
            if (!basicAnim.autoreverses) {
                theLayer.setValue(basicAnim.toValue, forKeyPath: basicAnim.keyPath!)
            }
        }else if let keyAnim = anim as? CAKeyframeAnimation{
            if (!keyAnim.autoreverses) {
                theLayer.setValue(keyAnim.values?.last, forKeyPath: keyAnim.keyPath!)
            }
        }else if let groupAnim = anim as? CAAnimationGroup{
            for subAnim in groupAnim.animations! as [CAAnimation]{
                updateValue(forAnimation: subAnim, theLayer: theLayer);
                
            }
        }
    }
    
    class func updateValueFromPresentationLayer(forAnimation anim: CAAnimation!, theLayer : CALayer){
        if let basicAnim = anim as? CABasicAnimation{
            theLayer.setValue(theLayer.presentation()?.value(forKeyPath: basicAnim.keyPath!), forKeyPath: basicAnim.keyPath!)
        }else if let keyAnim = anim as? CAKeyframeAnimation{
            theLayer.setValue(theLayer.presentation()?.value(forKeyPath: keyAnim.keyPath!), forKeyPath: keyAnim.keyPath!)
        }else if let groupAnim = anim as? CAAnimationGroup{
            for subAnim in groupAnim.animations! as [CAAnimation]{
                updateValueFromPresentationLayer(forAnimation: subAnim, theLayer: theLayer)
            }
        }
    }
}

// Utility methods that encapsulate the CoreGraphics API.
extension CGContext {
    func strokeLineFrom(from: CGPoint, to: CGPoint, color: UIColor, width: CGFloat, lineCap: CGLineCap) {
        self.setStrokeColor(color.cgColor)
        self.setLineWidth(width)
        self.setLineCap(lineCap)
        self.move(to: CGPoint(x: from.x, y: from.y))
        self.addLine(to: CGPoint(x: to.x, y: to.y))
        self.strokePath()
    }
    
    func fillRect(rect: CGRect, color: UIColor) {
        self.setFillColor(color.cgColor)
        self.fill(rect)
        self.strokePath()
    }
    
    func strokeRect(rect: CGRect, color: UIColor, width: CGFloat) {
        self.setLineWidth(width)
        self.setStrokeColor(color.cgColor)
        self.addRect(rect)
        self.strokePath()
    }
    
    func strokeEllipseInRect(rect: CGRect, color: UIColor, width: CGFloat) {
        self.setStrokeColor(color.cgColor)
        self.setLineWidth(width)
        self.addEllipse(in: rect)
        self.strokePath()
    }
}

extension CGRect {
    var bottomCenter: CGPoint { return CGPoint(x: midX, y: maxY) }
    var bottomLeft:   CGPoint { return CGPoint(x: minX, y: maxY) }
    var bottomRight:  CGPoint { return CGPoint(x: maxX, y: maxY) }
    var center:       CGPoint { return CGPoint(x: midX, y: midY) }
    var centerLeft:   CGPoint { return CGPoint(x: minX, y: midY) }
    var centerRight:  CGPoint { return CGPoint(x: maxX, y: midY) }
    var topCenter:    CGPoint { return CGPoint(x: midX, y: minY) }
    var topLeft:      CGPoint { return CGPoint(x: minX, y: minY) }
    var topRight:     CGPoint { return CGPoint(x: maxX, y: minY) }
    
    func insetBy(amount: CGFloat) -> CGRect {
        return self.insetBy(dx: amount, dy: amount)
    }
}

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
