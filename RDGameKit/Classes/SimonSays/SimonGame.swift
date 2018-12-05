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
    static let minimumSteps = 3
    static let maximumSteps = 8
    static let baseTimeInterval = 0.5

    /// The order of the correct steps
    let answer: [Int]

    /// The number of this level
    let levelNumber: Int

    /// How many steps have been correctly guessed by the user
    var correctAnswers: Int = 0

    /// The Delay to be used between lighting up buttons
    /// Speed increases as level increases beyond the maximum Steps
    let delay: TimeInterval

    init(level: Int, buttonCount: Int) {
        levelNumber = level

        var sequence = [Int]()
        let numberOfSteps = min(level + SimonGameLevel.minimumSteps, SimonGameLevel.maximumSteps)
        for _ in 1...numberOfSteps {
            sequence.append(Int.random(in: 0..<buttonCount))
        }

        answer = sequence
        print(sequence)

        let levelsPastMaxSteps = max(0, (level + SimonGameLevel.minimumSteps) - SimonGameLevel.maximumSteps)
        let delayMultiplier = Double(levelsPastMaxSteps) * 0.1
        let adjustedTime = SimonGameLevel.baseTimeInterval - (SimonGameLevel.baseTimeInterval * delayMultiplier)
        delay = max(0.01, adjustedTime)
    }

    /// Returns true when the provided index is next in the order of correct answers
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
        playSequence(level.answer, delay: level.delay)
    }

    private func playSequence(_ indexes: [Int], delay: TimeInterval) {
        gameState = .highlighting

        let chain = ClosureChain()

        indexes.enumerated().forEach { offset, index in
            chain.chainAfterDelay(delay) { [unowned self] in
                let button = self.simonView.gameButtons[index]
                button.setHighlighted(true, timeAllowed: delay)
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
