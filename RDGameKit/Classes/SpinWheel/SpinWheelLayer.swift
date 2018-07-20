//
//  SpinWheelLayer.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 19/7/18.
//

import Foundation
import UIKit
import CoreGraphics


open class SpinWheelLayer: CALayer  {
    
    /// Used to center the drawing such that offseted graphics(e.g Shadows, Outer Glows) are not clipped.
    /// Can be increased to any size if needed.
    open var layerInsets:UIEdgeInsets = UIEdgeInsetsMake(-50, -50, -50, -50)
    
    var mainFrame:CGRect!
    weak var parent: SpinWheel!
    private var initialOffset:CGFloat!
    
    public init(frame: CGRect, parent: SpinWheel, initialOffset: CGFloat = 0.0) {
        super.init()
        mainFrame = CGRect(origin: CGPoint(x: abs(layerInsets.left), y: abs(layerInsets.top)), size: frame.size)
        self.frame = UIEdgeInsetsInsetRect(frame, layerInsets)
        self.parent = parent
        self.initialOffset = initialOffset
        self.backgroundColor = UIColor.clear.cgColor
        self.contentsScale = UIScreen.main.scale
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        guard parent.slices != nil else {
            assert(false, "Slices parameter not set.")
            return
        }
        UIGraphicsPushContext(ctx)
        drawCanvas(mainFrame: mainFrame)
        UIGraphicsPopContext()
    }
    
    open func drawCanvas(mainFrame: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Main Group
        context.saveGState()
        if let shadow = parent.shadow {
            context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        }
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        //// Slice drawings
        var rotation:CGFloat = initialOffset
        parent.slices.enumerated().forEach { (index,element) in
            if let previousSlice = parent.slices[safe:(index - 1)] {
                rotation += (degree(of:previousSlice) + degree(of:element)) / 2
            }
            print("\(index): \(rotation)")
            self.drawSlice(withIndex: index, in: context, forSlice: element,rotation:rotation)
        }
        
        //// Frame drawing
        let circleFrame = UIBezierPath(ovalIn: mainFrame)
        parent.cirleFrameStroke.color.setStroke()
        circleFrame.lineWidth = parent.cirleFrameStroke.width
        circleFrame.stroke()
    
        context.endTransparencyLayer()
        context.restoreGState()
    }
    
    //MARK:- Computed values and expressions
    private var radius:CGFloat { return mainFrame.height / 2.0 }
    private var rotationOffset:CGFloat { return (mainFrame.width) / 2 + abs(layerInsets.top) }
    private func circularSegmentHeight(from degree:CGFloat) -> CGFloat { return 2 * radius * sin(degree / 2.0 * CGFloat.pi/180) }
    
    private func degree(of slice: SpinWheelSliceProtocol) -> CGFloat {
        return parent.sliceDegree ?? slice.degree
    }
    
    //MARK:- Graphics drawings
    open func drawSlice(withIndex index:Int, in context:CGContext, forSlice slice: SpinWheelSliceProtocol, rotation:CGFloat) {
        ///// Constats declarations
        let sectionWidthDegrees = degree(of: slice)
        let kTitleOffset: CGFloat = slice.offsetFromExterior
        let titleXValue: CGFloat = mainFrame.minX + kTitleOffset
        let kTitleWidth: CGFloat = 0.6
        let titleWidthCoeficient: CGFloat = sin(sectionWidthDegrees / 2.0 * CGFloat.pi/180)
        let titleWidthValue: CGFloat = (kTitleWidth + titleWidthCoeficient * 0.2) * radius
        let startAngle: CGFloat = 180 + sectionWidthDegrees / 2.0
        let endAngle: CGFloat = 180 - sectionWidthDegrees / 2.0
        let circularSegmentHeight: CGFloat = self.circularSegmentHeight(from:sectionWidthDegrees)
        let titleHeightValue: CGFloat = circularSegmentHeight * 1
        let titleYPosition: CGFloat = mainFrame.minY + mainFrame.height / 2.0 - titleHeightValue / 2.0
        
        //// Context setup
        context.saveGState()
        context.translateBy(x: rotationOffset, y: rotationOffset)
        context.rotate(by: rotation * CGFloat.pi/180)
        
        //// Slice drawing
        let sliceRect = CGRect(x: (mainFrame.minX - rotationOffset), y: (mainFrame.minY - rotationOffset), width: mainFrame.width, height: mainFrame.height)
        let slicePath = UIBezierPath()
        slicePath.addArc(withCenter: CGPoint(x: sliceRect.midX, y: sliceRect.midY), radius: sliceRect.width / 2, startAngle: -startAngle * CGFloat.pi/180, endAngle: -endAngle * CGFloat.pi/180, clockwise: true)
        slicePath.addLine(to: CGPoint(x: sliceRect.midX, y: sliceRect.midY))
        slicePath.close()
        slice.backgroundColor?.setFill()
        slicePath.fill()
        
        //// Strike drawing
        if let stroke = slice.stroke {
            stroke.color.setStroke()
            slicePath.lineWidth = stroke.width
            slicePath.stroke()
        }
        
        //// Title  Drawing
        let textRect = CGRect(x: (titleXValue - rotationOffset), y: (titleYPosition - rotationOffset), width: titleWidthValue, height: titleHeightValue)
//        let textTextContent = slice.title
        
        //// Set title attributes
//        let textStyle = NSMutableParagraphStyle()
//        textStyle.alignment = .left
//        var textFontAttributes = slice.textAttributes
//        textFontAttributes[.paragraphStyle] = textStyle
//
//        let textTextHeight: CGFloat = textTextContent.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
//        context.saveGState()
        //context.clip(to: textRect)
        //textTextContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        
        
        /// Logo  Drawing
        let newImage = UIImage(cgImage: slice.icon.cgImage!, scale: 1, orientation: UIImageOrientation.left)
        print("image: \(newImage.size)")
        
        let xP: CGFloat = -158.5
        let yP: CGFloat = -26
        
        let imageWidth = textRect.width - 10
        let imageHeight: CGFloat = 44
        
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        imageView.image = newImage
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        let convertedImage = imageView.createImage()
        
        convertedImage!.draw(in: CGRect(x: xP, y: yP, width: imageWidth, height: imageHeight))
        
        context.restoreGState()
        //context.restoreGState()
        
        print("\(context.height)")
    }
}

extension UIView {
    func createImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
            // Fallback on earlier versions
        }
        
    }
}

