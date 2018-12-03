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
    let simon: SimonGame

    init() {
        gameView = SimonGameView()
        simon = SimonGame(simonView: gameView)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        gameView = SimonGameView()
        simon = SimonGame(simonView: gameView)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        simon.delegate = self

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

extension SimonGameVC: SimonGameDelegate {
    func simonGameDidGameOver(_ simonGame: SimonGame) {
        let alert = UIAlertController(title: "Game Over",
                                      message: "Score: \(simonGame.currentScore)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
            self?.simon.reset()
            self?.simon.start()
        }))

        present(alert, animated: true, completion: nil)
    }
}
