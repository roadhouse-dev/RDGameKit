//
//  Game.swift
//  TicTacToe
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//
import Foundation

/** Represents a Tic-tac-toe contestant, either human or computer. */
internal final class Player {
    
    private let gameBoard: GameBoard
    private let strategy: TicTacToeStrategy
    init(mark: Mark, gameBoard: GameBoard, strategy: TicTacToeStrategy) {
        self.mark = mark
        self.gameBoard = gameBoard
        self.strategy = strategy
    }
    
    let mark: Mark
    
    func choosePositionWithCompletionHandler(completionHandler: @escaping (GameBoard.Position) -> Void) {
        strategy.choosePositionForMark(mark: mark, onGameBoard: gameBoard, completionHandler: completionHandler)
    }
    

}

/** The possible states for a position on a GameBoard. */
public enum Mark {
    case X, O
    
    func opponentMark() -> Mark {
        switch self {
        case .X: return .O
        case .O: return .X
        }
    }
}

/** Orchestrates gameplay between two players. */
public final class Game {
    
    public typealias CompletionHandler = (Outcome) -> Void

    public init(gameBoard: GameBoard, xStrategy: TicTacToeStrategy, oStrategy: TicTacToeStrategy) {
        self.gameBoard = gameBoard
        self.outcomeAnalyst = OutcomeAnalyst(gameBoard: gameBoard)
        self.playerX = Player(mark: .X, gameBoard: gameBoard, strategy: xStrategy)
        self.playerO = Player(mark: .O, gameBoard: gameBoard, strategy: oStrategy)
    }
    
    public func startPlayingWithCompletionHandler(completionHandler: @escaping CompletionHandler) {
        assert(self.completionHandler == nil, "Cannot start the same Game twice.")
        self.completionHandler = completionHandler
        currentPlayer = playerX
    }
    
    // MARK: - Non-public stored properties
    private var currentPlayer: Player? {
        didSet {
            currentPlayer?.choosePositionWithCompletionHandler(completionHandler: processChosenPosition)
        }
    }
    
    private var completionHandler: CompletionHandler!
    private let gameBoard: GameBoard
    private let outcomeAnalyst: OutcomeAnalyst
    private let playerO: Player
    private let playerX: Player
}

// MARK: - Private methods
private extension Game {
    func processChosenPosition(position: GameBoard.Position) {
        guard let currentPlayer = currentPlayer else {
            assertionFailure("Why was a position chosen if there is no current player?")
            return
        }
        
        gameBoard.putMark(mark: currentPlayer.mark, atPosition: position)
        
        log(position: position)
        
        if let outcome = outcomeAnalyst.checkForOutcome() {
            finishWithOutcome(outcome: outcome)
        }
        else {
            switchCurrentPlayer()
        }
    }
    
    func log(position: GameBoard.Position) {
        print("--- \(currentPlayer!.mark) played (\(position.row), \(position.column)) ---\n\(gameBoard.textRepresentation)\n")
    }
    
    func finishWithOutcome(outcome: Outcome) {
        completionHandler(outcome)
        currentPlayer = nil
    }
    
    func switchCurrentPlayer() {
        let xIsCurrent = (currentPlayer!.mark == .X)
        currentPlayer = xIsCurrent ? playerO : playerX
    }
}
