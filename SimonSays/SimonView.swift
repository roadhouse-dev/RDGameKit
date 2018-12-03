//
//  SimonView.swift
//  Pods-RDGameKit_Example
//
//  Created by Bryan Hathaway on 30/11/18.
//

import UIKit

public protocol SimonViewDelegate: class {
    func simonView(_ simonView: SimonView, didSelectIndex index: Int)
}

public protocol SimonGameButton {
    func setHighlighted(_ highlighted: Bool)
    func setEnabled(_ enabled: Bool)
}

public enum SimonFeedback {
    case incorrect
    case correct
}

open class SimonView: UIView {
    public weak var delegate: SimonViewDelegate?

    public var gameButtons: [SimonGameButton] = []


    public func displayGameOver() {}
    public func setScore(_ score: Int) {}
    public func provideFeedback(_ type: SimonFeedback) {}

    /// Highlights the gameButtons that match the values of the indexes array, in order.
    public func showSequence(_ indexes: [Int]) {
        animateSequence(indexes, delay: 0.0)
    }

    // MARK: Private
    private func animateSequence(_ indexes: [Int], delay: TimeInterval) {
        let chain = ClosureChain()

        indexes.enumerated().forEach { count, index in
            chain.chainAfterDelay(count == 0 ? 0.0 : 0.5) {
                let button = self.gameButtons[index]
                button.setHighlighted(true)
            }
        }

        chain.resume()

    }



}
