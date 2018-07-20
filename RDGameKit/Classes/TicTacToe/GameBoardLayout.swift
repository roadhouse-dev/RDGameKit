//
//  GameBoardLayout.swift
//  TicTacToeApp
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

import UIKit

/** Calculates sizes and positions used to render a game board. */
final class GameBoardLayout {
    
    typealias Line = (startPoint: CGPoint, endPoint: CGPoint)

    init(frame: CGRect, marksPerAxis: Int) {
        self.frame = frame
        self.marksPerAxis = marksPerAxis
    }
    
    lazy var outerBorderRect: CGRect = {
        let
        width  = self.frame.width,
        height = self.frame.height,
        length = min(width, height) - (BoardAppearance.sharedInstance.platformMarginWidth * 2),
        origin = CGPoint(x: width/2 - length/2, y: height/2 - length/2),
        size   = CGSize(width: length, height: length)
        return CGRect(origin: origin, size: size)
    }()
    
    lazy var innerBorderRect: CGRect = {
        return self.outerBorderRect.insetBy(amount: BoardAppearance.sharedInstance.outerBorderWidth)
    }()
    
    lazy var platformRect: CGRect = {
        return self.innerBorderRect.insetBy(amount: BoardAppearance.sharedInstance.innerBorderWidth)
    }()
    
    lazy var gridLines: [Line] = {
        let
        cellLength    = self.platformRect.width / CGFloat(self.marksPerAxis),
        lineNumbers   = 1..<self.marksPerAxis,
        verticalLines = lineNumbers.map { lineNumber -> Line in
            let x = self.platformRect.minX + CGFloat(lineNumber) * cellLength
            return Line(
                startPoint: CGPoint(x: x, y: self.platformRect.minY),
                endPoint:   CGPoint(x: x, y: self.platformRect.maxY))
        },
        horizontalLines = lineNumbers.map { lineNumber -> Line in
            let y = self.platformRect.minY + CGFloat(lineNumber) * cellLength
            return Line(
                startPoint: CGPoint(x: self.platformRect.minX, y: y),
                endPoint:   CGPoint(x: self.platformRect.maxX, y: y))
        }
        return verticalLines + horizontalLines
    }()
    
    func cellRectsAtPositions(positions: [GameBoard.Position]) -> [CGRect] {
        return positions.map(cellRectAtPosition)
    }
    
    private func cellRectAtPosition(position: GameBoard.Position) -> CGRect {
        let
        length = platformRect.width / CGFloat(marksPerAxis),
        left   = platformRect.minX + CGFloat(position.column) * length,
        top    = platformRect.minY + CGFloat(position.row) * length
        return CGRect(x: left, y: top, width: length, height: length)
    }
    
    func markRectAtPosition(position: GameBoard.Position) -> CGRect {
        let cellRect = cellRectAtPosition(position: position)
        return cellRect.insetBy(amount: BoardAppearance.sharedInstance.gridLineWidth/2 + BoardAppearance.sharedInstance.markMarginWidth)
    }

    func lineThroughWinningPositions(winningPositions: [GameBoard.Position]) -> Line {
        let
        cellRects   = cellRectsAtPositions(positions: winningPositions),
        startRect   = cellRects.first!,
        endRect     = cellRects.last!,
        orientation = winningLineOrientationForStartRect(startRect: startRect, endRect: endRect),
        startPoint  = startPointForRect(rect: startRect, winningLineOrientation: orientation),
        endPoint    = endPointForRect(rect: endRect, winningLineOrientation: orientation)
        return (startPoint, endPoint)
    }
    
    private enum WinningLineOrientation {
        case Horizontal, Vertical, TopLeftToBottomRight, BottomLeftToTopRight
    }
    
    private func winningLineOrientationForStartRect(startRect: CGRect, endRect: CGRect) -> WinningLineOrientation {
        let
        x1 = Int(startRect.minX), x2 = Int(endRect.minX),
        y1 = Int(startRect.minY), y2 = Int(endRect.minY)
        if x1 == x2 { return .Vertical }
        if y1 == y2 { return .Horizontal }
        if y1 <  y2 { return .TopLeftToBottomRight }
        return .BottomLeftToTopRight
    }
    
    private func startPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        let winningRect = rect.insetBy(amount: BoardAppearance.sharedInstance.winningLineInsetWidth)
        switch winningLineOrientation {
        case .Horizontal:           return winningRect.centerLeft
        case .Vertical:             return winningRect.topCenter
        case .TopLeftToBottomRight: return winningRect.topLeft
        case .BottomLeftToTopRight: return winningRect.bottomLeft
        }
    }
    
    private func endPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        let winningRect = rect.insetBy(amount: BoardAppearance.sharedInstance.winningLineInsetWidth)
        switch winningLineOrientation {
        case .Horizontal:           return winningRect.centerRight
        case .Vertical:             return winningRect.bottomCenter
        case .TopLeftToBottomRight: return winningRect.bottomRight
        case .BottomLeftToTopRight: return winningRect.topRight
        }
    }
    
    private let frame: CGRect
    private let marksPerAxis: Int
}
