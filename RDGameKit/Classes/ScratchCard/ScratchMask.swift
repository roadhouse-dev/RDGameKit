//
//  ScratchMask.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 17/7/18.
//

import UIKit

class ScratchMask: UIImageView {
    
    weak var delegate: ScratchCardDelegate?
    
    var lineType:CGLineCap!
    var lineWidth: CGFloat!
    var lastPoint: CGPoint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard  let touch = touches.first else {
            return
        }
        lastPoint = touch.location(in: self)
        delegate?.scratchBegan?(point: lastPoint!)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard  let touch = touches.first, let point = lastPoint, let img = image else {
            return
        }
        
        //get latest touch location
        let newPoint = touch.location(in: self)
        //erase mask between two points
        eraseMask(fromPoint: point, toPoint: newPoint)
        //save current touch location=
        lastPoint = newPoint
        
        //caculate the erased image percentage
        let progress = getAlphaPixelPercent(img: img)
        
        delegate?.scratchMoved?(progress: progress)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  touches.first != nil else {
            return
        }
        delegate?.scratchEnded?(point: lastPoint!)
    }
    
    func eraseMask(fromPoint: CGPoint, toPoint: CGPoint) {
        //create image context base on size
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        
        //draw image first
        image?.draw(in: self.bounds)
        
        //draw path
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineType)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear) //BlendMode is clear
        context.addPath(path)
        context.strokePath()
        
        //show the mixed image
        image = UIGraphicsGetImageFromCurrentImageContext()
        //finish draw image
        UIGraphicsEndImageContext()
    }
    
    private func getAlphaPixelPercent(img: UIImage) -> Float {
        //caculate all bitmapByte
        let width = Int(img.size.width)
        let height = Int(img.size.height)
        let bitmapByteCount = width * height
        
        //get all pixel data
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width,
                                space: colorSpace,
                                bitmapInfo: CGBitmapInfo(rawValue:
                                    CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(rect)
        context.draw(img.cgImage!, in: rect)
        
        //get clear color pixel
        var alphaPixelCount = 0
        for x in 0...Int(width) {
            for y in 0...Int(height) {
                if pixelData[y * width + x] == 0 {
                    alphaPixelCount += 1
                }
            }
        }
        
        free(pixelData)
        return Float(alphaPixelCount) / Float(bitmapByteCount)
    }
}

