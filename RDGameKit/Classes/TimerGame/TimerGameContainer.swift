//
//  TimerGameVC.swift
//  GameSample
//
//  Created by Max Ma on 5/10/18.
//  Copyright © 2018 Roadhouse. All rights reserved.
//

import UIKit

public protocol TimerGameContainerDelegate {
    func getResult(result: Double)
}

class TimerGameContainer: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var targetTimerLabel: UILabel!
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0

    //convar targetSeconds = 100.3
    var delegate: TimerGameContainerDelegate?
    
    var currentSeconds = 0
    var counter = 0

    @IBOutlet weak var tapButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    public func setUp(backgroundImage: UIImage, logo: UIImage, description: String) {
        self.logoView.image = logo
        self.descriptionLabel.text = description
        self.backgroundImageView.image = backgroundImage
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TimerGameContainer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func updateUI(ms:Int) {
        let myTimeInterval = TimeInterval(ms.msToSeconds)
        targetTimerLabel.text = myTimeInterval.toReadableString()
    }

    @IBAction func runTimer(_ sender: Any) {
        //tapButton.isEnabled = false
        counter += 1

        if counter == 2 {
            self.tapButton.isEnabled = false;
            self.tapButton.setTitle("Your time", for: .normal)
            //update enter button
            timer?.invalidate()
            
            delegate?.getResult(result: time)
            
        } else {
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
        
        //The rest of your code goes here
        
        //Convert the time to a string with 2 decimal places
        //let timeString = String(format: "%.2f", time)
        
        //Display the time string to a label in our view controller
        timerLabel.text = time.toReadableString()
        //print()
    }
    
  
}
extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

extension TimeInterval {
    
    func toReadableString() -> String {
        
        // Milliseconds
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        // Seconds
        let s = Int(self) % 60
        // Minutes
        let mn = (Int(self) / 60) % 60
        // Hours
        let hr = (Int(self) / 3600)
        
        var readableStr = ""
        if hr != 0 {
            //readableStr += String(format: "%0.2dhr ", hr)
            //dont deal with hour
        }
        
        if mn != 0 {
            readableStr += String(format: "%0.2d:", mn)
        } else {
            readableStr += "00:"
        }
        
        if s != 0 {
            readableStr += String(format: "%0.2d:", s)
        } else {
            readableStr += "00:"
        }
        
        if ms != 0 {
            readableStr += String(format: "%0.2d", ms)
        } else {
            readableStr += "00"
        }
        
        return readableStr
}
}
