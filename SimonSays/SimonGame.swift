//
//  SimonGame.swift
//  Pods-RDGameKit_Example
//
//  Created by Bryan Hathaway on 30/11/18.
//

import Foundation

public protocol SimonGameDelegate: class {
    func simonGameDidGameOver(_ simonGame: SimonGame)
}

private struct SimonGameLevel {
    let answer: [Int]
    let levelNumber: Int
    var correctAnswers: Int = 0

    init(level: Int, buttonCount: Int) {
        levelNumber = level

        var sequence = [Int]()
        for _ in 0...level {
            sequence.append(Int.random(in: 0..<buttonCount))
        }

        answer = sequence
    }

    func isUserGuessCorrect(_ index: Int) -> Bool {
        return answer[correctAnswers] == index
    }
}

public class SimonGame {
    private let simonView: SimonView
    private var currentLevel: SimonGameLevel
    public var currentScore: Int {
        return currentLevel.levelNumber
    }

    public weak var delegate: SimonGameDelegate?

    public init(simonView: SimonView) {
        self.simonView = simonView
        currentLevel = SimonGameLevel(level: 0, buttonCount: simonView.gameButtons.count)

        simonView.delegate = self
    }

    public func start() {
        begin(level: currentLevel)
    }

    public func reset() {
        currentLevel = SimonGameLevel(level: 0, buttonCount: simonView.gameButtons.count)
    }

    private func begin(level: SimonGameLevel) {
        currentLevel = level
        simonView.showSequence(level.answer)
    }
}

extension SimonGame: SimonViewDelegate {
    public func simonView(_ simonView: SimonView, didSelectIndex index: Int) {
        if currentLevel.isUserGuessCorrect(index) {

            currentLevel.correctAnswers += 1

            if currentLevel.correctAnswers == currentLevel.answer.count {
                let nextLevelNumber = currentLevel.levelNumber + 1
                simonView.setScore(nextLevelNumber)
                let nextLevel = SimonGameLevel(level: nextLevelNumber,
                                               buttonCount: simonView.gameButtons.count)
                begin(level: nextLevel)

            } else {
                simonView.provideFeedback(.correct)
            }

        } else {
            simonView.displayGameOver()
            delegate?.simonGameDidGameOver(self)
        }
    }

}
