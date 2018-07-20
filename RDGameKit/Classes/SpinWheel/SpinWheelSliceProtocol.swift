//
//  FortuneWheelSliceProtocol.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 19/7/18.
//

public struct StrokeInfo {
    public var color:UIColor
    public var width:CGFloat
    
    public init(color:UIColor, width:CGFloat) {
        self.color = color
        self.width = width
    }
}

public protocol SpinWheelSliceProtocol {
    
    //// Properties
    var title:String { get }
    var description:String { get }

    var icon:UIImage { get }
    var backgroundColor:UIColor? { get set}
    var degree:CGFloat { get }
    var stroke:StrokeInfo? { get }
    var offsetFromExterior:CGFloat { get }
    
    //// Can provide any text attributes except NSMutableParagraphStyle which will allways be centered
    var textAttributes: [NSAttributedStringKey:Any] { get }
    
    //// Can be overriten individualy. textAttributes is used if set.
    var fontSize:CGFloat { get }
    var fontColor:UIColor { get }
    var font:UIFont { get }
    
}

extension SpinWheelSliceProtocol {
        
    public var fontSize:CGFloat { return 18.0 }
    public var fontColor:UIColor { return UIColor.black }
    public var font:UIFont { return UIFont.systemFont(ofSize: fontSize, weight: .regular) }
    
    public var textAttributes:[NSAttributedStringKey:Any] {
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        let deafultAttributes:[NSAttributedStringKey: Any] =
            [.font: self.font,
             .foregroundColor: self.fontColor,
             .paragraphStyle: textStyle ]
        return deafultAttributes
    }
    
    public var offsetFromExterior:CGFloat { return 10.0 }
    
    public var stroke:StrokeInfo? { return nil }
    
    public var backgroundColor:UIColor? { return UIColor.lightGray }
}
