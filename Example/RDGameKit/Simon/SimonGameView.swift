//
//  SimonGameView.swift
//  RDGameKit_Example
//
//  Created by Bryan Hathaway on 30/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import RDGameKit

class SimonGameView: SimonView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = #colorLiteral(red: 0.1291881502, green: 0.1486565769, blue: 0.1612132788, alpha: 1)
        let colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
        let buttons = (0..<colors.count).map { _ in
            newButton()
        }

        buttons.enumerated().forEach { index, button in
            button.layer.borderColor = colors[index].cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)

            button.onSelection = { [weak self] in
                self?.delegate?.simonView(self!, didSelectIndex: index)
            }

            let size: CGFloat = 75
            button.widthAnchor.constraint(equalToConstant: size).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true

            button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

            let topConst = (size + 10) * CGFloat(index + 1)
            button.topAnchor.constraint(equalTo: topAnchor, constant: topConst).isActive = true
        }

        gameButtons = buttons


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func newButton() -> GameButton {
        let view = GameButton()
        view.layer.borderWidth = 5.0

        return view
    }

    override func displayGameOver() {


    }
    
}

class GameButton: UIView, SimonGameButton {
    var onSelection: (() -> ())?

    public func setHighlighted(_ highlighted: Bool) {
        backgroundColor = UIColor(cgColor: layer.borderColor!)
        layer.shadowColor = layer.borderColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 20.0
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
        return UIColor(cgColor: layer.borderColor!).withAlphaComponent(0.3)
    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        backgroundColor = highlightColor
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
    }
}
