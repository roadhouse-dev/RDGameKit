//
//  SimonView.swift
//  Pods-RDGameKit_Example
//
//  Created by Bryan Hathaway on 30/11/18.
//

import UIKit

protocol SimonViewDelegate: class {
    func simonView(_ simonView: SimonView, didSelectIndex index: Int)
}

protocol SimonGameButton {
    func setHighlighted(_ highlighted: Bool)
    func setEnabled(_ enabled: Bool)
}

enum SimonFeedback {
    case incorrect
    case correct
}

class SimonView: UIView {
    weak var delegate: SimonViewDelegate?

    var gameButtons: [SimonGameButton] = []


    func displayGameOver() {}
    func setScore(_ score: Int) {}
    func provideFeedback(_ type: SimonFeedback) {}

    /// Highlights the gameButtons that match the values of the indexes array, in order.
    func showSequence(_ indexes: [Int], delayIntervals: [TimeInterval] = []) {
        animateSequence(indexes, intervals: delayIntervals, index: 0, delay: 0.0)
    }

    // MARK: Private
    private func animateSequence(_ indexes: [Int], intervals: [TimeInterval], index: Int, delay: TimeInterval) {

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + delay, execute: {
            DispatchQueue.main.async {
                self.gameButtons.enumerated().forEach { btnIndex, button in
                    button.setEnabled(index == btnIndex)
                }
            }
        })

        let nextIndex = index + 1
        guard nextIndex < indexes.count else { return }

        var nextDelay = intervals.last ?? 0.1
        if index < intervals.count {
            nextDelay = intervals[index]
        }

        animateSequence(indexes, intervals: intervals, index: nextIndex, delay: nextDelay)

    }



}
