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

        let buttons = (0...5).map { _ in
            newButton()
        }

        buttons.enumerated().forEach { index, button in
            let colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)]
            button.layer.borderColor = colors[index].cgColor

            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)

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

    private func newButton() -> UIView {
        let view = UIView()
        view.layer.borderWidth = 5.0

        return view
    }
    
}

extension UIView: SimonGameButton {

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
}
