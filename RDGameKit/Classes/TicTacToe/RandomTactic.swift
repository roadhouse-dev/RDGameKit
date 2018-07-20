//
//  RandomTactic.swift
//  GameSample
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

import Foundation

/**
 Tactic #1 in Newell and Simon's strategy.
 If the player can play one mark to win, returns the winning position.
 */
struct RandomTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        if gameBoard.emptyPositions.count > 0 {
            let randomNumber =  Int(arc4random_uniform(UInt32(gameBoard.emptyPositions.count)))
            return gameBoard.emptyPositions[randomNumber]
        } else {
            return nil
        }
    }
}
