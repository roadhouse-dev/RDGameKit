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

    public func setHighlighted(_ highlighted: Bool) {
        backgroundColor = UIColor(cgColor: layer.borderColor!)
        layer.shadowColor = layer.borderColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 25.0
        layer.shadowOpacity = highlighted ? 1.0 : 0.0

        layoutIfNeeded()

        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
            self.backgroundColor = .clear

        }, completion: { _ in
            self.layer.shadowOpacity = 0.0
        })
    }

    public func setEnabled(_ enabled: Bool) {

    }

    private var highlightColor: UIColor {
        return UIColor(cgColor: layer.borderColor!).withAlphaComponent(0.5)
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
            backgroundColor = nil
            return
        }

        if backgroundColor == nil {
            backgroundColor = highlightColor
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let location = touches.first?.location(in: self) else { return }
        guard bounds.contains(location) else { return }
        onSelection?()
        backgroundColor = nil

        haptic.impactOccurred()
    }
}
