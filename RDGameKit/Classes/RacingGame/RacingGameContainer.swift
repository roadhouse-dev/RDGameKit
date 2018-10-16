//
//  RacingGameContainer.swift
//  RDGameKit
//
//  Created by Max Ma on 15/10/18.
//

import UIKit

public protocol RacingGameContainerDelegate {
    func entryButtonClicked(playerTime: TimeInterval, boltTime: TimeInterval)
}

public class RacingGameContainer: UIView {
    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var descriptionText = ""
    
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
    var boltTime: TimeInterval = TimeInterval(1)
    var playerTime: TimeInterval = TimeInterval(0)
    
    var playerStartUpTime: Int?
    var playerEndUpTime: Int?

    var numbersFinished = 0
    public var delegate: RacingGameContainerDelegate?

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
    
    public func configUI(description: String, boltTime: TimeInterval, steps: Int) {
        print("configUI")
        self.descriptionText = description
        self.descriptionLabel.text = description
        self.resultLabel.text = ""
        self.boltTime = boltTime
        self.steps = steps
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
        
        self.playerStartUpTime = nil
        self.playerEndUpTime = nil
        
        self.descriptionLabel.text = self.descriptionText
        self.resultLabel.text = ""
        
        startGameTimer()
    }
    
    private func startGameTimer() {
        self.startButton.isEnabled = false
        
        self.startCouterLabel.text = "\(countDownSeconds)"
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownToStart), userInfo: nil, repeats: true)
    }
    
    @IBAction func enterToWin(_ sender: Any) {
        self.delegate?.entryButtonClicked(playerTime: self.playerTime, boltTime: self.boltTime)
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
        if playerStartUpTime == nil {
            playerStartUpTime = self.upTime()
        }
        
        self.trackWidth = firstTrackView.frame.width - 84
        
        self.leadingConstraint.constant = self.trackWidth
        print("runFirstPlayer s uptime: \(upTime())")

//        UIView.animate(withDuration: boltTime) {
//            self.layoutIfNeeded()
//            self.checkGameEnd()
//        }
        
        UIView.animate(withDuration: boltTime, animations: {
            self.layoutIfNeeded()
        }) { (isCompleted) in
            print("runFirstPlayer isCompleted: \(isCompleted)")
            self.checkGameEnd()
        }
    }
    
    private func moveSecondUser() {
   

        self.trackWidth = firstTrackView.frame.width - 84
        
        let stepLength = (self.trackWidth + 18)/CGFloat(steps)
        
        self.secondLeadingConstraint.constant = self.secondLeadingConstraint.constant + stepLength
        
        self.currentStep += 1

        UIView.animate(withDuration:0.2) {
            self.layoutIfNeeded()

            if self.currentStep >= self.steps {
                self.playerEndUpTime = self.upTime()
                
                self.controlArea.isHidden = true
                self.entryArea.isHidden = false
                self.checkGameEnd()
            }
        }
    }
    
    func checkGameEnd() {
        numbersFinished += 1
        
        if numbersFinished == 2 {
            self.updateResult()
            self.numbersFinished = 0
        }
        print("runFirstPlayer e uptime: \(upTime())")
        print("checkGameEnd")
    }
    
    func updateResult() {

        guard let startTime = playerStartUpTime, let endTime = playerEndUpTime else {
            return
        }

        let time = endTime - startTime
        self.playerTime = TimeInterval(Double(time)/1000.0)
        print("s - e time: \(playerTime)")
        
        if self.playerTime < boltTime {
            self.descriptionLabel.text = "Congradulations, you beat Usain Bolts record."
        } else {
            self.descriptionLabel.text = "You didn't beat Usain Bolt this time."
        }

        self.resultLabel.text = "Your Time: \(self.playerTime.toReadableString())"
    }
    
    public func upTime() -> Int {
        var bootTime = timeval()
        var currentTime = timeval()
        var timeZone = timezone()
        
        let mib = UnsafeMutablePointer<Int32>.allocate(capacity: 2)
        mib[0] = CTL_KERN
        mib[1] = KERN_BOOTTIME
        var size = MemoryLayout.size(ofValue: bootTime)
        
        var timeSinceBoot = 0.0
        
        gettimeofday(&currentTime, &timeZone)
        
        if sysctl(mib, 2, &bootTime, &size, nil, 0) != -1 && bootTime.tv_sec != 0 {
            timeSinceBoot = Double(currentTime.tv_sec - bootTime.tv_sec)
            timeSinceBoot += Double(currentTime.tv_usec - bootTime.tv_usec) / 1000000.0
        }
        let milliseconds = Int(timeSinceBoot * 1000)
        
        return milliseconds
    }
    
}
