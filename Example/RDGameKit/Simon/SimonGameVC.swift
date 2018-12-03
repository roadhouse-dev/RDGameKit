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
