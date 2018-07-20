//
//  GameBoardRenderer.swift
//  TicTacToeApp
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

//import TicTacToe
import UIKit

/** Draws a game board on the screen. */
final class GameBoardRenderer {
    
    private let context: CGContext
    private let gameBoard: GameBoard
    private let layout: GameBoardLayout
    
    init(context: CGContext, gameBoard: GameBoard, layout: GameBoardLayout) {
        self.context = context
        self.gameBoard = gameBoard
        self.layout = layout
    }
    
    func renderWithWinningPositions(winningPositions: [GameBoard.Position]?) {
        renderBorder()
        renderPlatform()
        renderGridLines()
        renderMarks()
        if let winningPositions = winningPositions {
            renderLineThroughWinningPositions(winningPositions: winningPositions)
        }
    }

}

// MARK: - Rendering routines
private extension GameBoardRenderer {
    func renderBorder() {
        context.strokeRect(rect: layout.outerBorderRect, color: BoardAppearance.sharedInstance.outerBorderColor, width: BoardAppearance.sharedInstance.outerBorderWidth)
        context.strokeRect(rect: layout.innerBorderRect, color: BoardAppearance.sharedInstance.innerBorderColor, width: BoardAppearance.sharedInstance.innerBorderWidth)
    }
    
    func renderPlatform() {
        context.fillRect(rect: layout.platformRect, color: BoardAppearance.sharedInstance.platformColor)
    }
    
    func renderGridLines() {
        layout.gridLines.forEach {
            context.strokeLineFrom(from: $0.startPoint, to: $0.endPoint, color: BoardAppearance.sharedInstance.gridLineColor, width: BoardAppearance.sharedInstance.gridLineWidth, lineCap: .butt)
        }
    }
    
    func renderMarks() {
        gameBoard.marksAndPositions
            .map     { (arg) ->  (mark: Mark, position: CGRect) in let (mark, position) = arg; return (mark, layout.markRectAtPosition(position: position)) }
            .forEach { (arg) in let (mark, markRect) = arg; renderMark(mark: mark, inRect: markRect) }
    }
    
    func renderMark(mark: Mark, inRect rect: CGRect) {
        switch mark {
        case .X: renderX(inRect: rect)
        case .O: renderO(inRect: rect)
        }
    }
    
    func renderX(inRect rect: CGRect) {
        context.strokeLineFrom(from: rect.topLeft, to: rect.bottomRight, color: BoardAppearance.sharedInstance.markXColor, width: BoardAppearance.sharedInstance.markWidth, lineCap: .round)
        context.strokeLineFrom(from: rect.bottomLeft, to: rect.topRight, color: BoardAppearance.sharedInstance.markXColor, width: BoardAppearance.sharedInstance.markWidth, lineCap: .round)
    }
    
    func renderO(inRect rect: CGRect) {
        context.strokeEllipseInRect(rect: rect, color: BoardAppearance.sharedInstance.markOColor, width: BoardAppearance.sharedInstance.markWidth)
    }
    
    func renderLineThroughWinningPositions(winningPositions: [GameBoard.Position]) {
        let (startPoint, endPoint) = layout.lineThroughWinningPositions(winningPositions: winningPositions)
        context.strokeLineFrom(from: startPoint, to: endPoint, color: BoardAppearance.sharedInstance.winningLineColor, width: BoardAppearance.sharedInstance.winningLineWidth, lineCap: .round)
    }
}
