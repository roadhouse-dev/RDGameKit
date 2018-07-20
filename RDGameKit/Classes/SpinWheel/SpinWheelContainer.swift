//
//  SpinWheelContainer.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 19/7/18.
//

import UIKit

public protocol SpinWheelContainerDelegate {
    func getPrize(slice: SpinWheelSliceProtocol)
}

public class SpinWheelContainer: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var bottomLogoImageView: UIImageView!
    @IBOutlet var spinButton: UIButton!
    @IBOutlet var prizeView: UIView!
    @IBOutlet var spinWheel: SpinWheel!
    @IBOutlet var spinWheelBackgroundImageView: UIImageView!
    
    @IBOutlet var prizeIcon: UIImageView!
    @IBOutlet var prizeNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    open var spinWheelContainerDelegate: SpinWheelContainerDelegate?

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
        let nib = UINib(nibName: "SpinWheelContainer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    public func setUp(backgroundImage: UIImage, logo: UIImage, bottomLogo: UIImage, spinButtonImage: UIImage, spinBackImage: UIImage, slices: [SpinWheelSliceProtocol]) {
        self.logoImageView.image = logo
        self.bottomLogoImageView.image = bottomLogo
        self.backgroundImageView.image = backgroundImage
        self.spinButton.setImage(spinButtonImage, for: .normal)
        
        spinWheel.slices = slices
        spinWheel.equalSlices = true
        spinWheel.frameStroke.width = 0
    }
    
    @IBAction func rotate(_ sender: Any) {
        self.hidePrize()
        let number = arc4random_uniform(UInt32(spinWheel.slices.count))
        let slice = spinWheel.slices[Int(number)]
        self.prizeIcon.image = slice.icon
        self.prizeNameLabel.text = slice.title
        self.descriptionLabel.text = slice.description
        print("number: \(number)")
        spinWheel.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.spinWheel.startAnimating(fininshIndex: Int(number)) { (finished) in
                print(finished)
                if finished {
                    self.showPrize(slice: slice)
                }
            }
        }
    }
    
    private func showPrize(slice: SpinWheelSliceProtocol) {
        UIView.animate(withDuration: 1, animations: {
            self.prizeView.frame.origin.y = self.frame.height - 150
            self.spinWheelContainerDelegate?.getPrize(slice: slice)
        })
    }
    
    private func hidePrize() {
        self.prizeView.isHidden = true
        self.prizeView.frame.origin.y = self.frame.height + 180
        self.prizeView.isHidden = false
    }
}
