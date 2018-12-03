//
//  SimonGameView.swift
//  RDGameKit_Example
//
//  Created by Bryan Hathaway on 30/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import RDGameKit

class SimonGameView: UIView {

    var gameButtons: [SimonGameButton] = []
    var onGameButtonSelected: ((Int) -> ())? = nil

    let scoreLabel = UILabel()
    let infoLabel = UILabel()
    let haptic = UINotificationFeedbackGenerator()

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
                self?.onGameButtonSelected?(index)
            }

            let size: CGFloat = 75
            button.widthAnchor.constraint(equalToConstant: size).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true

            button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

            let topConst = (size + 10) * CGFloat(index + 1)
            button.topAnchor.constraint(equalTo: topAnchor, constant: topConst).isActive = true
        }

        gameButtons = buttons

        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 2
        addSubview(scoreLabel)

        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        infoLabel.font = UIFont(name: "Noteworthy-Bold", size: 32.0)
        infoLabel.textAlignment = .center
        addSubview(infoLabel)

        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32.0),

            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: buttons.last!.bottomAnchor, constant: 64.0)
            ])


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func newButton() -> SimonButton {
        let view = SimonButton()
        view.layer.borderWidth = 5.0

        return view
    }

    private func showInfoLabel(text: String?, color: UIColor) {
        infoLabel.text = text
        infoLabel.textColor = color
        infoLabel.alpha = 1.0
        layoutIfNeeded()

        UIView.animate(withDuration: 0.4, delay: 0.6, options: [], animations: {
            self.infoLabel.alpha = 0
        }, completion: nil)
    }
}

extension SimonGameView: SimonView {

    func setScore(_ score: Int) {
        scoreLabel.text = "SCORE\n\(score)"
    }

    func provideFeedback(_ type: SimonFeedback) {

        switch type {
        case .correct:
            showInfoLabel(text: "Correct!", color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))

        case .incorrect:
            showInfoLabel(text: "Wrong!", color: #colorLiteral(red: 0.8888163285, green: 0.1818342134, blue: 0.09008045312, alpha: 1))
            haptic.notificationOccurred(.error)
        }

    }
}

