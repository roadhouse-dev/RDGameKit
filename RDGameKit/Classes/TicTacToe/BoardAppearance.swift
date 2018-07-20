//
//  Thickness.swift
//  TicTacToeApp
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

import UIKit

/** The thickness/width of user interface elements. */
public class BoardAppearance {
    static let sharedInstance = BoardAppearance()
    public init() {}
    var
    gridLineWidth: CGFloat         =  2,
    innerBorderWidth: CGFloat      =  1,
    markWidth: CGFloat             = 16,
    markMarginWidth: CGFloat       = 20,
    outerBorderWidth: CGFloat      =  1,
    platformMarginWidth: CGFloat   = 16,
    winningLineWidth: CGFloat      =  8,
    winningLineInsetWidth: CGFloat =  8
    
    var
    gridLineColor    = UIColor.darkGray,
    innerBorderColor = UIColor.darkGray,
    markOColor       = UIColor.blue,
    markXColor       = UIColor.green,
    outerBorderColor = UIColor.white,
    platformColor    = UIColor.white,
    winningLineColor = UIColor.red
}

public class GameBoardSettings {
    //static let sharedInstance = BoardAppearance()
    public init() {}
    public var
    gridLineWidth: CGFloat         =  2,
    innerBorderWidth: CGFloat      =  1,
    markWidth: CGFloat             = 16,
    markMarginWidth: CGFloat       = 20,
    outerBorderWidth: CGFloat      =  1,
    platformMarginWidth: CGFloat   = 16,
    winningLineWidth: CGFloat      =  8,
    winningLineInsetWidth: CGFloat =  8
    
    public var
    gridLineColor    = UIColor.darkGray,
    innerBorderColor = UIColor.darkGray,
    markOColor       = UIColor.blue,
    markXColor       = UIColor.green,
    outerBorderColor = UIColor.white,
    platformColor    = UIColor.white,
    winningLineColor = UIColor.red
    
    public func updateBoardAppearance() {
        BoardAppearance.sharedInstance.gridLineWidth = self.gridLineWidth
        BoardAppearance.sharedInstance.innerBorderWidth = self.innerBorderWidth
        BoardAppearance.sharedInstance.markWidth = self.markWidth
        BoardAppearance.sharedInstance.markMarginWidth = self.markMarginWidth
        BoardAppearance.sharedInstance.outerBorderWidth = self.outerBorderWidth
        BoardAppearance.sharedInstance.platformMarginWidth = self.platformMarginWidth
        BoardAppearance.sharedInstance.winningLineWidth = self.winningLineWidth
        BoardAppearance.sharedInstance.gridLineColor = self.gridLineColor
        BoardAppearance.sharedInstance.innerBorderColor = self.innerBorderColor
        BoardAppearance.sharedInstance.markOColor = self.markOColor
        BoardAppearance.sharedInstance.markXColor = self.markXColor
        BoardAppearance.sharedInstance.outerBorderColor = self.outerBorderColor
        BoardAppearance.sharedInstance.platformColor = self.platformColor
        BoardAppearance.sharedInstance.winningLineColor = self.winningLineColor

    }
}
