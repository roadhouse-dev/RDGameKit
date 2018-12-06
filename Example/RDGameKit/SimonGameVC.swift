//
//  SimonGameVC.swift
//  RDGameKit_Example
//
//  Created by Bryan Hathaway on 30/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RDGameKit

class SimonGameVC: UIViewController {
    let gameView: SimonGameView
    var simon: SimonGame!

    init() {
        gameView = SimonGameView()
        super.init(nibName: nil, bundle: nil)
        simon = SimonGame(simonView: self, config: SimonConfig.standard)
    }

    required init?(coder aDecoder: NSCoder) {
        gameView = SimonGameView()
        super.init(coder: aDecoder)
        simon = SimonGame(simonView: self, config: SimonConfig.standard)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        gameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameView)

        NSLayoutConstraint.activate([
            gameView.topAnchor.constraint(equalTo: view.topAnchor),
            gameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        simon.start()
    }
}

extension SimonGameVC: SimonHandler {
    var gameButtons: [SimonGameButton] {
        return gameView.gameButtons
    }

    var onGameButtonSelected: ((Int) -> ())? {
        get { return gameView.onGameButtonSelected }
        set { gameView.onGameButtonSelected = newValue }
    }

    func setScore(_ score: Int) {
        gameView.setScore(score)
    }

    func finishLevel(_ type: SimonFeedback) {
        gameView.provideFeedback(type)

        if type == .incorrect {
            showGameOver()
        } else {
            simon.nextLevel()
        }
    }

    func showGameOver() {
        let alert = UIAlertController(title: "Game Over",
                                      message: "Score: \(simon.currentScore)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
            self?.simon.reset()
            self?.simon.start()
        }))

        present(alert, animated: true, completion: nil)
    }
}
