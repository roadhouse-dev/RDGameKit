//
//  NewellAndSimonStrategy.swift
//  TicTacToe
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

import Foundation

/** 
 An intelligent agent which implements Newell and Simon's Tic-tac-toe strategy for a 3x3 game board.
 For more details, refer to strategy.pdf.
 */

protocol NewellAndSimonTactic {
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position?
}

final class NewellAndSimonStrategy: TicTacToeStrategy {
    
    let randomTactic = RandomTactic()
    let isSmart: Bool

    init(tactics: [NewellAndSimonTactic] = [
        WinTactic(),
        BlockTactic(),
        ForkTactic(),
        BlockForkTactic(),
        CenterTactic(),
        OppositeCornerTactic(),
        EmptyCornerTactic(),
        EmptySideTactic()
        ], isSmart: Bool) {
        self.tactics = tactics
        self.isSmart = isSmart
    }
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard, completionHandler: @escaping (GameBoard.Position) -> Void) {
        assert(gameBoard.dimension >= 3)
        if isSmart {
            let position = tactics.reduce(nil) { (position, tactic) in
                position ?? tactic.choosePositionForMark(mark: mark, onGameBoard: gameBoard)
            }
            completionHandler(position!)
        } else {
            let randomPosition = randomTactic.choosePositionForMark(mark: mark, onGameBoard: gameBoard)
            completionHandler(randomPosition!)
        }

    }
    
    private let tactics: [NewellAndSimonTactic]
}
