//
//  WinTactic.swift
//  TicTacToe
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

import Foundation

/** 
 Tactic #1 in Newell and Simon's strategy.
 If the player can play one mark to win, returns the winning position.
 */
struct WinTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        for emptyPosition in gameBoard.emptyPositions {
            let
            possibleBoard  = gameBoard.cloneWithMark(mark: mark, atPosition: emptyPosition),
            outcomeAnalyst = OutcomeAnalyst(gameBoard: possibleBoard)
            if let outcome = outcomeAnalyst.checkForOutcome() {
                assert(outcome.winner == nil || outcome.winner == Winner.fromMark(mark: mark))
                return emptyPosition
            }
        }
        return nil
    }
}

/**
 Tactic #2 in Newell and Simon's strategy.
 If the opponent can play one mark to win, returns the position to block/occupy.
 */
struct BlockTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return WinTactic().choosePositionForMark(mark: mark.opponentMark(), onGameBoard: gameBoard)
    }
}

/**
 Tactic #3 in Newell and Simon's strategy.
 If the player can play one mark to create two ways to win on their next turn, returns that mark's position.
 */
struct ForkTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        assert(gameBoard.dimension >= 3)
        
        return findForkPositionsForMark(mark: mark, onGameBoard: gameBoard).first
    }
    
    internal func findForkPositionsForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> [GameBoard.Position] {
        let
        indexes       = gameBoard.dimensionIndexes,
        diagonals     = GameBoard.Diagonal.allValues(),
        rowInfos      = indexes.map   { Info(marks: gameBoard.marksInRow(row: $0),      positions: gameBoard.positionsForRow(row: $0))      },
                                      columnInfos   = indexes.map   { Info(marks: gameBoard.marksInColumn(column: $0),   positions: gameBoard.positionsForColumn(column: $0))   },
                                                                    diagonalInfos = diagonals.map { Info(marks: gameBoard.marksInDiagonal(diagonal: $0), positions: gameBoard.positionsForDiagonal(diagonal: $0)) }
        
        let
        forkableRowInfos      = rowInfos.filter      { $0.isForkableWithMark(mark: mark) },
                                                     forkableColumnInfos   = columnInfos.filter   { $0.isForkableWithMark(mark: mark) },
                                                                                                  forkableDiagonalInfos = diagonalInfos.filter { $0.isForkableWithMark(mark: mark) }
        
        return [
            findForkPositionsWithInfos(infos: forkableRowInfos,      andOtherInfos: forkableColumnInfos  ),
            findForkPositionsWithInfos(infos: forkableRowInfos,      andOtherInfos: forkableDiagonalInfos),
            findForkPositionsWithInfos(infos: forkableColumnInfos,   andOtherInfos: forkableDiagonalInfos),
            findForkPositionsWithInfos(infos: forkableDiagonalInfos, andOtherInfos: forkableDiagonalInfos)]
            .flatMap { $0 }
    }
    
    private func findForkPositionsWithInfos(infos: [Info], andOtherInfos otherInfos: [Info]) -> [GameBoard.Position] {
        return infos.flatMap { self.findForkPositionsWithInfo(info: $0, andOtherInfos: otherInfos) }
    }
    
    private func findForkPositionsWithInfo(info: Info, andOtherInfos otherInfos: [Info]) -> [GameBoard.Position] {
        return otherInfos
            .filter  { info.markedPosition != $0.markedPosition  }
            .flatMap { info.findIntersectingPositionWithInfo(info: $0) }
    }
}

/**
 Tactic #4 in Newell and Simon's strategy.
 If the opponent can play one mark to create two ways to win on their next turn,
 returns a position that forces the opponent to block on their next turn,
 or, if no offensive play is possible, returns the position to block the fork.
 */
struct BlockForkTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        assert(gameBoard.dimension >= 3)
        
        // This tactic is only applicable when the opponent can create a fork.
        guard let forkPosition = findForkPositionForMark(mark: mark.opponentMark(), onGameBoard: gameBoard) else {
            return nil
        }
        
        // An offensive position is 'safe' if it does not enable the opponent to create a fork by blocking it.
        let safeOffensivePosition = findSafeOffensivePositionForMark(mark: mark, onGameBoard: gameBoard)
        return safeOffensivePosition ?? forkPosition
    }
    
    private func findForkPositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return ForkTactic().choosePositionForMark(mark: mark, onGameBoard: gameBoard)
    }
    
    private func findSafeOffensivePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return gameBoard.emptyPositions
            .filter { isSafeOffensivePosition(offensivePosition: $0, forMark: mark, onGameBoard: gameBoard) }
            .first
    }
    
    private func isSafeOffensivePosition(offensivePosition: GameBoard.Position, forMark mark: Mark, onGameBoard gameBoard: GameBoard) -> Bool {
        let possibleGameBoard = gameBoard.cloneWithMark(mark: mark, atPosition: offensivePosition)
        
        guard let winningPosition = findWinningPositionForMark(mark: mark, onGameBoard: possibleGameBoard) else {
            return false
        }
        
        if wouldCreateForkForMark(mark: mark.opponentMark(), byBlockingPosition: winningPosition, onGameBoard: possibleGameBoard) {
            return false
        }
        
        return true
    }
    
    private func findWinningPositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return WinTactic().choosePositionForMark(mark: mark, onGameBoard: gameBoard)
    }
    
    private func wouldCreateForkForMark(mark: Mark, byBlockingPosition blockPosition: GameBoard.Position, onGameBoard gameBoard: GameBoard) -> Bool {
        let
        forkPositions  = ForkTactic().findForkPositionsForMark(mark: mark, onGameBoard: gameBoard),
        isForkingBlock = forkPositions.contains { $0 == blockPosition }
        return isForkingBlock
    }
}

/**
 Tactic #5 in Newell and Simon's strategy.
 If the center position is empty, returns the center position.
 */
struct CenterTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        assert(gameBoard.dimension >= 3)
        
        let center = GameBoard.Position(row: 1, column: 1)
        return gameBoard.isEmptyAtPosition(position: center) ? center : nil
    }
}

/**
 Tactic #6 in Newell and Simon's strategy.
 If the opponent is in a corner and the opposite corner (along the diagonal) is empty, returns the opposite corner position.
 */
struct OppositeCornerTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        assert(gameBoard.dimension >= 3)
        
        return GameBoard.Diagonal
            .allValues()
            .flatMap { choosePositionInDiagonal(diagonal: $0, forMark: mark, gameBoard: gameBoard) }
            .first
    }
    
    private func choosePositionInDiagonal(diagonal: GameBoard.Diagonal, forMark mark: Mark, gameBoard: GameBoard) -> GameBoard.Position? {
        let
        marks     = gameBoard.marksInDiagonal(diagonal: diagonal),
        positions = gameBoard.positionsForDiagonal(diagonal: diagonal),
        (leftMark, rightMark) = (marks[0],     marks[2]),
        (leftPos,  rightPos)  = (positions[0], positions[2])
        
        let opponent = mark.opponentMark()
        
        switch (leftMark, rightMark) {
        case (opponent?, nil): return rightPos
        case (nil, opponent?): return leftPos
        default:               return nil
        }
    }
}

/**
 Tactic #7 in Newell and Simon's strategy.
 If the center position is empty, returns the center position.
 */
struct EmptyCornerTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        let
        allCorners   = cornerPositionsForGameBoard(gameBoard: gameBoard),
        emptyCorners = allCorners.filter(gameBoard.isEmptyAtPosition)
        return emptyCorners.first
    }
    
    private func cornerPositionsForGameBoard(gameBoard: GameBoard) -> [GameBoard.Position] {
        assert(gameBoard.dimension >= 3)
        
        let
        topLeft     = GameBoard.Position(row: 0, column: 0),
        topRight    = GameBoard.Position(row: 0, column: 2),
        bottomRight = GameBoard.Position(row: 2, column: 2),
        bottomLeft  = GameBoard.Position(row: 2, column: 0)
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
}

/**
 Tactic #8 in Newell and Simon's strategy.
 If the a side position is empty, returns the side position.
 */
struct EmptySideTactic: NewellAndSimonTactic {
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        let
        allSides   = sidePositionsForGameBoard(gameBoard: gameBoard),
        emptySides = allSides.filter(gameBoard.isEmptyAtPosition)
        return emptySides.first
    }
    
    private func sidePositionsForGameBoard(gameBoard: GameBoard) -> [GameBoard.Position] {
        assert(gameBoard.dimension >= 3)
        
        let
        top    = GameBoard.Position(row: 0, column: 1),
        right  = GameBoard.Position(row: 1, column: 2),
        bottom = GameBoard.Position(row: 2, column: 1),
        left   = GameBoard.Position(row: 1, column: 0)
        return [top, right, bottom, left]
    }
}

private struct Info {
    let marks: [Mark?]
    let positions: [GameBoard.Position]
    
    func isForkableWithMark(mark: Mark) -> Bool {
        let
        nonNilMarks = marks.flatMap { $0 },
                                    onlyOneMark = nonNilMarks.count == 1,
        isRightMark = nonNilMarks.first == mark
        return onlyOneMark && isRightMark
    }
    
    var markedPosition: GameBoard.Position {
        let markIndex = marks.index { $0 != nil }
        return positions[markIndex!]
    }
    
    func findIntersectingPositionWithInfo(info: Info) -> GameBoard.Position? {
        return positions.filter { info.containsPosition(position: $0) }.first
    }
    
    func containsPosition(position: GameBoard.Position) -> Bool {
        return positions.contains { $0 == position }
    }
}
