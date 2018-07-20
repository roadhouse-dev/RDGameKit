//
//  TicTacToeContainer.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 20/7/18.
//

import UIKit

public protocol TicTacToeContainerDelegate {
    func getResult(result: (Int, Int, Int))
}

public class TicTacToeContainer: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tieLabel: UILabel!
    @IBOutlet weak var aiLabel: UILabel!
    @IBOutlet private weak var boardView: GameBoardView!
    private var game: Game?
    private var userStrategyX: UserStrategy?
    open var ticTacToeContainerDelegate: TicTacToeContainerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TicTacToeContainer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    public func setUp(backgroundImage: UIImage, gameBoardSettings: GameBoardSettings) {
        gameBoardSettings.updateBoardAppearance()
        boardView.gameBoardViewDelegate = self
        self.updateScore(winner: nil, isInit: true)
        startPlayingGame()
        self.backgroundImageView.image = backgroundImage
    }
    
    private func updateScore(winner: Winner?, isInit:Bool = false) {
        if isInit {
            self.userLabel.text = "0"
            self.aiLabel.text = "0"
            self.tieLabel.text = "0"
        } else {
            if let winner = winner {
                switch winner {
                case .PlayerO:
                    self.aiLabel.text = "\(Int(self.aiLabel.text!)! + 1)"
                case .PlayerX:
                    self.userLabel.text = "\(Int(self.userLabel.text!)! + 1)"
                }
            } else {
                self.tieLabel.text = "\(Int(self.tieLabel.text!)! + 1)"
            }
        }
        let userWins = Int(self.userLabel.text!) ?? 0
        let ties = Int(self.tieLabel.text!) ?? 0
        let aiWins = Int(self.aiLabel.text!) ?? 0

        ticTacToeContainerDelegate?.getResult(result: (userWins, ties, aiWins))
    }
    
    func startPlayingGame() {
        let gameBoard = GameBoard()
        boardView.gameBoard = gameBoard
        self.userStrategyX = UserStrategy()
        game = Game(gameBoard: gameBoard, xStrategy: self.userStrategyX!, oStrategy: UserStrategy().createArtificialIntelligenceStrategy(isSmart: randomBool()))
        game!.startPlayingWithCompletionHandler { [weak self] outcome in
            if let winner = outcome.winner {
                switch winner {
                case .PlayerO:
                    print("O win")
                case .PlayerX:
                    print("X win")
                }
            } else {
                print("outcome: the game may end in a tie")
            }
            self?.updateScore(winner: outcome.winner)
            self?.boardView.winningPositions = outcome.winningPositions
        }
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
}

extension TicTacToeContainer: GameBoardViewDelegate {
    func tappedFinishedGameBoard() {
        self.startPlayingGame()
    }
    
    func tappedEmptyPosition(position: GameBoard.Position) {
        if !reportChosenPosition(position: position, forUserStrategy: userStrategyX) {
            //reportChosenPosition(position: position, forUserStrategy: userStrategyO)
        }
        boardView.refreshBoardState()
    }
    
    func reportChosenPosition(position: GameBoard.Position, forUserStrategy userStrategy: UserStrategy?) -> Bool {
        guard let userStrategy = userStrategy, userStrategy.isWaitingToReportChosenPosition else {
            return false
        }
        
        userStrategy.reportChosenPosition(position: position)
        return true
    }
}
