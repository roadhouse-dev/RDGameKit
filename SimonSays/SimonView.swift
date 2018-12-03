//
//  SimonView.swift
//  Pods-RDGameKit_Example
//
//  Created by Bryan Hathaway on 30/11/18.
//

import UIKit

//public protocol SimonViewDelegate: class {
//    func simonView(_ simonView: SimonView, didSelectIndex index: Int)
//}

public protocol SimonGameButton {
    func setHighlighted(_ highlighted: Bool)
    func setEnabled(_ enabled: Bool)
}

public enum SimonFeedback {
    case incorrect
    case correct
}

public protocol SimonView {
    var gameButtons: [SimonGameButton] { get }
    var onGameButtonSelected: ((Int) -> ())? { get set }

    func setScore(_ score: Int)
    func provideFeedback( _ type: SimonFeedback)
}
