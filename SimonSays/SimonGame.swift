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

private enum SimonGameState {
    case guessing
    case highlighting
    case notPlaying
}

public class SimonGame {
    private var simonView: SimonView
    private var currentLevel: SimonGameLevel
    public var currentScore: Int {
        return currentLevel.levelNumber
    }

    private var gameState: SimonGameState = .notPlaying

    public weak var delegate: SimonGameDelegate?

    public init(simonView: SimonView) {
        self.simonView = simonView
        currentLevel = SimonGameLevel(level: 0, buttonCount: simonView.gameButtons.count)

        self.simonView.onGameButtonSelected = { [weak self] index in
            self?.handleSelectedIndex(index)
        }
    }

    // MARK: - Public

    public func start() {
        begin(level: currentLevel)
    }

    public func reset() {
        simonView.setScore(0)
        currentLevel = SimonGameLevel(level: 0, buttonCount: simonView.gameButtons.count)
    }

    // MARK: - Private

    private func begin(level: SimonGameLevel) {
        currentLevel = level
        playSequence(level.answer)
    }

    private func playSequence(_ indexes: [Int]) {
        gameState = .highlighting

        let chain = ClosureChain()

        indexes.enumerated().forEach { offset, index in
            chain.chainAfterDelay(offset == 0 ? 0.0 : 0.5) { [unowned self] in
                let button = self.simonView.gameButtons[index]
                button.setHighlighted(true)
            }
        }

        chain.chain {
            self.gameState = .guessing
        }

        chain.resume()
    }

    private func handleSelectedIndex(_ index: Int) {
        guard gameState == .guessing else { return }
        
        if currentLevel.isUserGuessCorrect(index) {

            currentLevel.correctAnswers += 1

            if currentLevel.correctAnswers == currentLevel.answer.count {
                simonView.provideFeedback(.correct)
                gameState = .highlighting

                let nextLevelNumber = currentLevel.levelNumber + 1
                simonView.setScore(nextLevelNumber)
                let nextLevel = SimonGameLevel(level: nextLevelNumber,
                                               buttonCount: simonView.gameButtons.count)

                ClosureChain().chainAfterDelay(1.0) {
                    self.begin(level: nextLevel)
                }.resume()


            } else {

            }

        } else {
            gameState = .notPlaying
            simonView.provideFeedback(.incorrect)
            delegate?.simonGameDidGameOver(self)
        }
    }

}
