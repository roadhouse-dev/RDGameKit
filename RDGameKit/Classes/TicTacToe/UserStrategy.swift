//
//  UserStrategy.swift
//  TicTacToeApp
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

import Foundation

public protocol TicTacToeStrategy {
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard, completionHandler: @escaping (GameBoard.Position) -> Void)
}

/** A Tic-tac-toe strategy that allows a person to decide where to put marks on a game board. */
final class UserStrategy: TicTacToeStrategy {
    
    func createArtificialIntelligenceStrategy(isSmart: Bool) -> TicTacToeStrategy {
        return NewellAndSimonStrategy(isSmart: isSmart)
    }
    
    func choosePositionForMark(mark: Mark, onGameBoard _: GameBoard, completionHandler: @escaping (GameBoard.Position) -> Void) {
        self.reportChosenPositionClosure = completionHandler
    }
    
    func reportChosenPosition(position: GameBoard.Position) {
        if let reportChosenPositionClosure = reportChosenPositionClosure {
            self.reportChosenPositionClosure = nil
            reportChosenPositionClosure(position)
        }
    }
    
    var isWaitingToReportChosenPosition: Bool {
        return reportChosenPositionClosure != nil
    }
    
    private var reportChosenPositionClosure: ((GameBoard.Position) -> Void)?
}
