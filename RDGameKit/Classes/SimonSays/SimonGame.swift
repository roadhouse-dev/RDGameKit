//
//  SimonGame.swift
//  Pods-RDGameKit_Example
//
//  Created by Bryan Hathaway on 30/11/18.
//

import Foundation

public struct SimonConfig {
    public static let standard = SimonConfig(minimumSteps: 3,
                                             maximumSteps: 8,
                                             baseTimeInterval: 0.5,
                                             speedIncreasePerLevelPastMaxSteps: 0.1)

    public let minimumSteps: Int
    public let maximumSteps: Int

    /// The base delay between highlighting each simon game button
    public let baseTimeInterval: TimeInterval

    /// 0.1 equates to a 10% decrease in base delay per level
    public let speedIncreasePerLevelPastMaxSteps: Double
}

private struct SimonGameLevel {
    /// The order of the correct steps
    let answer: [Int]

    /// The number of this level
    let levelNumber: Int

    /// How many steps have been correctly guessed by the user
    var correctAnswers: Int = 0

    /// The Delay to be used between lighting up buttons
    /// Speed increases as level increases beyond the maximum Steps
    let delay: TimeInterval

    init(level: Int, buttonCount: Int, config: SimonConfig) {
        levelNumber = level

        var sequence = [Int]()
        let numberOfSteps = min(level + config.minimumSteps, config.maximumSteps)
        for _ in 1...numberOfSteps {
            sequence.append(Int.random(in: 0..<buttonCount))
        }

        answer = sequence
        print(sequence)

        let levelsPastMaxSteps = max(0, (level + config.minimumSteps) - config.maximumSteps)
        let delayMultiplier = Double(levelsPastMaxSteps) * config.speedIncreasePerLevelPastMaxSteps
        let adjustedTime = config.baseTimeInterval - (config.baseTimeInterval * delayMultiplier)
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
    case waitingForNextLevel
    case notPlaying
}

public class SimonGame {
    private var simonView: SimonHandler
    private var currentLevel: SimonGameLevel
    public var currentScore: Int {
        return currentLevel.levelNumber
    }

    private var gameState: SimonGameState = .notPlaying
    private let config: SimonConfig

    public init(simonView: SimonHandler, config: SimonConfig) {
        self.simonView = simonView
        self.config = config
        currentLevel = SimonGameLevel(level: 0, buttonCount: simonView.gameButtons.count, config: config)

        self.simonView.onGameButtonSelected = { [weak self] index in
            self?.handleSelectedIndex(index)
        }
    }

    // MARK: - Public

    public func start() {
        begin(level: currentLevel)
    }

    public func nextLevel() {
        let nextLevelNumber = currentLevel.levelNumber + 1
        let nextLevel = SimonGameLevel(level: nextLevelNumber,
                                       buttonCount: simonView.gameButtons.count,
                                       config: config)
        begin(level: nextLevel)
    }

    public func reset() {
        simonView.setScore(0)
        currentLevel = SimonGameLevel(level: 0,
                                      buttonCount: simonView.gameButtons.count,
                                      config: config)
    }

    // MARK: - Private

    private func begin(level: SimonGameLevel) {
        currentLevel = level
        playSequence(level.answer, delay: level.delay)
    }

    private func playSequence(_ indexes: [Int], delay: TimeInterval) {
        gameState = .highlighting

        self.simonView.gameButtons.forEach { $0.setEnabled(false) }

        let chain = ClosureChain()

        indexes.enumerated().forEach { offset, index in
            chain.chainAfterDelay(delay) { [unowned self] in
                let button = self.simonView.gameButtons[index]
                button.setHighlighted(true, timeAllowed: delay, final: index == indexes.count - 1)
            }
        }

        chain.chain {
            self.simonView.gameButtons.forEach { $0.setEnabled(true) }
            self.gameState = .guessing
        }

        chain.resume()
    }

    private func handleSelectedIndex(_ index: Int) {
        guard gameState == .guessing else { return }
        
        if currentLevel.isUserGuessCorrect(index) {

            currentLevel.correctAnswers += 1

            if currentLevel.correctAnswers == currentLevel.answer.count {
                simonView.setScore(currentLevel.levelNumber + 1)
                simonView.finishLevel(.correct)
                gameState = .waitingForNextLevel

            }

        } else {
            gameState = .notPlaying
            simonView.finishLevel(.incorrect)
        }
    }

}
