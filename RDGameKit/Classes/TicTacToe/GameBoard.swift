//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Max Ma on 13/7/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

import Foundation

/** 
 Represents the state of a Tic-tac-toe game.
 Each position on the board can be empty or marked.
 A position is identified by zero-based row/column indexes.
 */
public final class GameBoard {
    
    public typealias Position = (row: Int, column: Int)

    public enum Diagonal {
        case TopLeftToBottomRight, BottomLeftToTopRight
        
        static func allValues() -> [Diagonal] {
            return [.TopLeftToBottomRight, .BottomLeftToTopRight]
        }
    }
    
    public convenience init(dimension: Int = 3) {
        assert(dimension >= 3)
        
        let
        emptyRow = [Mark?](repeating: nil, count: dimension),
        allMarks = [[Mark?]](repeating: emptyRow, count: dimension)
        
        self.init(dimension: dimension, marks: allMarks)
    }
    
    private init(dimension: Int, marks: [[Mark?]]) {
        self.dimension = dimension
        self.dimensionIndexes = [Int](0..<dimension)
        self.marks = marks
    }
    
    public let dimension: Int
    
    public var emptyPositions: [Position] {
        return positions.filter(isEmptyAtPosition)
    }
    
    public var marksAndPositions: [(mark: Mark, position: Position)] {
        return positions.flatMap { position in
            if let mark = markAtPosition(position: position) {
                return (mark, position)
            }
            else {
                return nil
            }
        }
    }
    
    // MARK: - Non-public stored properties
    internal let dimensionIndexes: [Int]
    internal var marks: [[Mark?]] // internal for unit test access
    
    private lazy var positions: [Position] = {
        self.dimensionIndexes.flatMap { row -> [Position] in
            let
            rows = [Int](repeating: row, count: self.dimension),
            cols = self.dimensionIndexes
            return Array(zip(rows, cols))
        }
    }()
}

// MARK: - Internal methods
internal extension GameBoard {
    func cloneWithMark(mark: Mark, atPosition position: Position) -> GameBoard {
        let clone = GameBoard(dimension: dimension, marks: [[Mark?]](marks))
        clone.putMark(mark: mark, atPosition: position)
        return clone
    }
    
    func isEmptyAtPosition(position: Position) -> Bool {
        return markAtPosition(position: position) == nil
    }
    
    func marksInRow(row: Int) -> [Mark?] {
        return positionsForRow(row: row).map(markAtPosition)
    }
    
    func marksInColumn(column: Int) -> [Mark?] {
        return positionsForColumn(column: column).map(markAtPosition)
    }
    
    func marksInDiagonal(diagonal: Diagonal) -> [Mark?] {
        return positionsForDiagonal(diagonal: diagonal).map(markAtPosition)
    }
    
    func positionsForRow(row: Int) -> [Position] {
        return dimensionIndexes.map { (row: row, column: $0) }
    }
    
    func positionsForColumn(column: Int) -> [Position] {
        return dimensionIndexes.map { (row: $0, column: column) }
    }
    
    func positionsForDiagonal(diagonal: Diagonal) -> [Position] {
        let rows = dimensionIndexes, columns = dimensionIndexes
        switch diagonal {
        case .TopLeftToBottomRight: return Array(zip(rows, columns))
        case .BottomLeftToTopRight: return Array(zip(rows.reversed(), columns))
        }
    }
    
    func putMark(mark: Mark, atPosition position: Position) {
        assertPosition(position: position)
        assert(isEmptyAtPosition(position: position))
        marks[position.row][position.column] = mark
    }
}

// MARK: - Private methods
private extension GameBoard {
    func assertIndex(index: Int) {
        assert(-1 < index && index < dimension)
    }
    
    func assertPosition(position: Position) {
        assertIndex(index: position.row)
        assertIndex(index: position.column)
    }
    
    func markAtPosition(position: Position) -> Mark? {
        assertPosition(position: position)
        return marks[position.row][position.column]
    }
}

// MARK: - Debugging
internal extension GameBoard {
    var textRepresentation: String {
        return marks
            .map(stringWithMarks)
            .joined(separator: "\n")
    }
    
    private func stringWithMarks(marks: [Mark?]) -> String {
        return marks
            .map(glyphForMark)
            .joined(separator: "")
    }
    
    private func glyphForMark(mark: Mark?) -> String {
        switch mark {
        case Mark.X?: return "X"
        case Mark.O?: return "O"
        case nil:     return "•"
        }
    }
}
