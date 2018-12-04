//
//  SimonButton.swift
//  RDGameKit_Example
//
//  Created by Bryan Hathaway on 3/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import RDGameKit

class SimonButton: UIView, SimonGameButton {
    var onSelection: (() -> ())?

    let haptic = UIImpactFeedbackGenerator(style: .light)

    public func setHighlighted(_ highlighted: Bool, timeAllowed: TimeInterval) {
        backgroundColor = backgroundColor?.withAlphaComponent(1.0)
        layer.shadowColor = layer.borderColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 25.0
        layer.shadowOpacity = highlighted ? 1.0 : 0.0

        layoutIfNeeded()

        let animationTime = timeAllowed * 0.9
        UIView.animate(withDuration: animationTime / 2.0, delay: animationTime / 2.0, options: [.curveEaseIn], animations: {
            self.backgroundColor = self.regularColor

        }, completion: { _ in
            self.layer.shadowOpacity = 0.0
        })
    }

    public func setEnabled(_ enabled: Bool) {

    }

    private var highlightColor: UIColor? {
        return backgroundColor?.withAlphaComponent(0.6)
    }

    private var regularColor: UIColor? {
        return backgroundColor?.withAlphaComponent(0.3)
    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        backgroundColor = highlightColor

        haptic.prepare()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        guard bounds.contains(location) else {
            backgroundColor = regularColor
            return
        }

        if backgroundColor == regularColor {
            backgroundColor = highlightColor
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let location = touches.first?.location(in: self) else { return }
        guard bounds.contains(location) else { return }
        onSelection?()
        backgroundColor = regularColor

        haptic.impactOccurred()
    }
}
