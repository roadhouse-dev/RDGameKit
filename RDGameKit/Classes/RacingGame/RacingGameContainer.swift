//
//  RacingGameContainer.swift
//  RDGameKit
//
//  Created by Max Ma on 15/10/18.
//

import UIKit

public class RacingGameContainer: UIView {
    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playerOneImageView: UIImageView!
    @IBOutlet weak var firstTrackView: UIView!
    
    var trackWidth: CGFloat = 0.0
    
    var gameTimer: Timer!
    var countDownTimer: Timer!
    var countDownSeconds = 3
    @IBOutlet weak var countDownView: TimerBackView!
    
    var leftIsClicked = false
    var rightIsClicked = false
    @IBOutlet weak var startCouterLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var controlArea: UIView!
    @IBOutlet weak var entryArea: UIView!
    
    var steps = 10
    var currentStep = 0
    var firstPlayerDuration: CGFloat = 4.0

    var playerStartTime: TimeInterval?
    var playerEndTime: TimeInterval?

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
        
        let nib = UINib(nibName: "RacingGameContainer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    public func configUI(backgroundImage: UIImage, description: String) {
        print("configUI")
        self.descriptionLabel.text = description
        self.backgroundImageView.image = backgroundImage
        self.resultLabel.text = ""
    }
    

    
    @IBAction func leftClicked(_ sender: Any) {
        self.leftIsClicked = true
        self.rightIsClicked = false

    }
    
    @IBAction func rightClicked(_ sender: Any) {
        self.rightIsClicked = true
        
        if self.leftIsClicked, self.rightIsClicked {
            // move
            self.moveSecondUser()
            self.leftIsClicked = false
            self.rightIsClicked = false
        } else {
            self.leftIsClicked = false
            self.rightIsClicked = false
        }
        
    }
    
    @IBAction func start(_ sender: Any) {
        startGameTimer()
    }
    
    @IBAction func retry(_ sender: Any) {
        self.secondLeadingConstraint.constant = -18
        self.leadingConstraint.constant = -18
        self.layoutIfNeeded()
        self.currentStep = 0
        
        self.controlArea.isHidden = false
        self.entryArea.isHidden = true
        self.countDownView.isHidden = false
        self.countDownSeconds = 3
        startGameTimer()
    }
    
    private func startGameTimer() {
        self.startButton.isEnabled = false
        
        self.startCouterLabel.text = "\(countDownSeconds)"
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownToStart), userInfo: nil, repeats: true)
    }
    
    @IBAction func enterToWin(_ sender: Any) {
        
    }
    
    
    @objc func countDownToStart(timer: Timer) {
        countDownSeconds -= 1
        self.startCouterLabel.text = "\(countDownSeconds)"

        if countDownSeconds <= 0 {
            self.countDownTimer.invalidate()
            self.countDownView.isHidden = true
            
            self.runFirstPlayer()
        }

    }
    
    @objc func runFirstPlayer() {
        self.trackWidth = firstTrackView.frame.width - 80
        
        self.leadingConstraint.constant = self.trackWidth
        UIView.animate(withDuration:TimeInterval(firstPlayerDuration)) {
            self.layoutIfNeeded()
        }
    }
    
    private func moveSecondUser() {
        if playerStartTime == nil {
            playerStartTime = Date().timeIntervalSinceReferenceDate
        }
       

        self.trackWidth = firstTrackView.frame.width - 80
        
        let stepLength = (self.trackWidth + 18)/CGFloat(steps)
        
        self.secondLeadingConstraint.constant = self.secondLeadingConstraint.constant + stepLength
        
        self.currentStep += 1

        UIView.animate(withDuration:0.2) {
            self.layoutIfNeeded()

            if self.currentStep >= self.steps {
                self.playerEndTime = Date().timeIntervalSinceReferenceDate
                self.controlArea.isHidden = true
                self.entryArea.isHidden = false
                self.updateResult()
            }
        }
    }
    
    func updateResult() {
        guard let startTime = playerStartTime, let endTime = playerEndTime else {
            return
        }
        
        let time = endTime - startTime
        self.resultLabel.text = time.toReadableString()
    }
    
}
