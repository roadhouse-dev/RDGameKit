//
//  TimerPageContainer.swift
//  RDGameKit
//
//  Created by Max Ma on 10/10/18.
//

import UIKit

public protocol TimerGameContainerDelegate {
    func getResult(result: Double)
    func getError(result: String)

}

public class TimerPageContainer: UIView {
    @IBOutlet var contentView: UIView!

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var targetTimerLabel: UILabel!
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    public var delegate: TimerGameContainerDelegate?
    
    var currentSeconds = 0
    var counter = 0
    
    @IBOutlet weak var tapAreaButton: UIButton!
    
    @IBOutlet weak var controlAreaBottomCT: NSLayoutConstraint!
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

        let nib = UINib(nibName: "TimerPageContainer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    public func configUI(backgroundImage: UIImage, description: String, targetMs:Int) {
        if targetMs < 99999 {
            self.descriptionLabel.text = description
            //self.backgroundImageView.image = backgroundImage
            
            let myTimeInterval = TimeInterval(targetMs.msToSeconds)
            self.targetTimerLabel.text = myTimeInterval.toReadableString()
        } else {
            self.delegate?.getError(result: "Superhuam time should less than 99:999")
        }
        print("configUI")
    }
    
    private func showControlArea() {
        self.controlAreaBottomCT.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func retry(_ sender: Any) {
        self.controlAreaBottomCT.constant = -180
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
            self.tapAreaButton.isEnabled = true
        }
        
        self.counter = 0
        self.tapAreaButton.setTitle("START", for: .normal)
        self.runTimer("nil")
    }
    
    @IBAction func addToLeaderBoard(_ sender: Any) {
        delegate?.getResult(result: time)
    }
    
    
    @IBAction func runTimer(_ sender: Any) {
        counter += 1
        
        if counter == 2 {
            //update enter button
            self.tapAreaButton.isEnabled = false
            timer?.invalidate()
            showControlArea()
            
        } else {
            self.tapAreaButton.setTitle("STOP", for: .normal)

            startTime = Date().timeIntervalSinceReferenceDate
            timer = Timer.scheduledTimer(timeInterval: 0.05,
                                         target: self,
                                         selector: #selector(advanceTimer(timer:)),
                                         userInfo: nil,
                                         repeats: true)
        }
        
    }
    
    @objc func advanceTimer(timer: Timer) {
        
        //Total time since timer started, in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        if time < 99.999 {
            timerLabel.text = time.toReadableString()
        } else {
            //stop
            timer.invalidate()
            //time = 99.999
            //timerLabel.text = time.toReadableString()
            self.delegate?.getError(result: "over limitaion")
            print("over limitaion")
        }
        //The rest of your code goes here
        
        //Convert the time to a string with 2 decimal places
        //let timeString = String(format: "%.2f", time)
        
        //Display the time string to a label in our view controller
        
    
        //print()
    }

}
