//
//  GameBoardView.swift
//  TicTacToeApp
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//
import UIKit

protocol GameBoardViewDelegate: class {
    func tappedEmptyPosition(position: GameBoard.Position)
    func tappedFinishedGameBoard()
}

/** Displays the lines and marks of a Tic-tac-toe game. */
final class GameBoardView: UIView {
    
    weak var gameBoardViewDelegate: GameBoardViewDelegate?

    var gameBoard: GameBoard? {
        didSet {
            _layout = nil
            _renderer = nil
            winningPositions = nil
        }
    }
    
    var winningPositions: [GameBoard.Position]? {
        didSet { refreshBoardState() }
    }
    
    func refreshBoardState() {
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if gameBoard != nil {
            handleTouchesEnded(touches: touches)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if gameBoard != nil {
            renderer.renderWithWinningPositions(winningPositions: winningPositions)
        }
    }
    
    private var _renderer: GameBoardRenderer?
    private var renderer: GameBoardRenderer {
        assert(gameBoard != nil)
        if _renderer == nil {
            // By the time a renderer is needed, this view's graphics context should exist.
            let context = UIGraphicsGetCurrentContext()!
            _renderer = GameBoardRenderer(context: context, gameBoard: gameBoard!, layout: layout)
        }
        return _renderer!
    }
    
    private var _layout: GameBoardLayout?
    private var layout: GameBoardLayout {
        assert(gameBoard != nil)
        if _layout == nil {
            // By the time a layout is needed, this view's frame should reflect its actual size.
            _layout = GameBoardLayout(frame: frame, marksPerAxis: gameBoard!.dimension)
        }
        return _layout!
    }
}

// MARK: - Touch handling
private extension GameBoardView {
    func handleTouchesEnded(touches: Set<UITouch>) {
        if isGameFinished {
            reportTapOnFinishedGameBoard()
        }
        else if let touch = touches.first, let emptyPosition = emptyPositionFromTouch(touch: touch) {
            reportTapOnEmptyPosition(position: emptyPosition)
        }
    }
    
    var isGameFinished: Bool {
        let
        wasWon  = winningPositions != nil,
        wasTied = gameBoard?.emptyPositions.count == 0
        return wasWon || wasTied
    }
    
    func emptyPositionFromTouch(touch: UITouch) -> GameBoard.Position? {
        guard let gameBoard = gameBoard else { return nil }
        
        let
        touchLocation  = touch.location(in: self),
        emptyPositions = gameBoard.emptyPositions,
        emptyCellRects = layout.cellRectsAtPositions(positions: emptyPositions)
        
        return zip(emptyPositions, emptyCellRects)
            .compactMap { (position, cellRect) in cellRect.contains(touchLocation) ? position : nil }
            .first
    }
    
    func reportTapOnFinishedGameBoard() {
        gameBoardViewDelegate?.tappedFinishedGameBoard()
    }
    
    func reportTapOnEmptyPosition(position: GameBoard.Position) {
        gameBoardViewDelegate?.tappedEmptyPosition(position: position)
    }
}
