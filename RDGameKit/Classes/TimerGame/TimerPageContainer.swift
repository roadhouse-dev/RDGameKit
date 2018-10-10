//
//  TimerPageContainer.swift
//  RDGameKit
//
//  Created by Max Ma on 10/10/18.
//

import UIKit

public protocol TimerGameContainerDelegate {
    func getResult(result: Double)
}

public class TimerPageContainer: UIView {
    @IBOutlet var contentView: UIView!

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var targetTimerLabel: UILabel!
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    public var delegate: TimerGameContainerDelegate?
    
    var currentSeconds = 0
    var counter = 0
    
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
        //let bundle = Bundle(for: self.classForCoder())
        //let bundle = Bundle(for:TimerPageContainer.self)

        let nib = UINib(nibName: "TimerPageContainer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    public func configUI(backgroundImage: UIImage, logo: UIImage, description: String, targetMs:Int) {
        print("configUI")
        self.descriptionLabel.text = description
        self.logoView.image = logo
        self.backgroundImageView.image = backgroundImage
        
        let myTimeInterval = TimeInterval(targetMs.msToSeconds)
        self.targetTimerLabel.text = myTimeInterval.toReadableString()
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

