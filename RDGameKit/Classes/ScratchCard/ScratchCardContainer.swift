//
//  ScrachCardContainer.swift
//  RoadhouseGameKit
//
//  Created by Max Ma on 17/7/18.
//
import UIKit

@objc public protocol ScratchCardContainerDelegate {
    @objc optional func getPrize()
}

public class ScratchCardContainer: UIView {
    
    @IBOutlet weak var prizeImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var bottomLogoImageView: UIImageView!
    @IBOutlet weak var scratchCard: ScratchCard!
    private var displayed = false
    @IBOutlet weak var backgroundImageView: UIImageView!
    open var scratchCardContainerDelegate: ScratchCardContainerDelegate?
    
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
        let nib = UINib(nibName: "ScratchCardContainer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    public func setUp(backgroundImage: UIImage, logo: UIImage, bottomLogo: UIImage, couponImage: UIImage, maskImage: UIImage) {
        self.logoImageView.image = logo
        self.bottomLogoImageView.image = bottomLogo
        self.backgroundImageView.image = backgroundImage
        
        scratchCard.createScratchView(couponImage: couponImage, maskImage: maskImage)
        scratchCard.delegate = self
    }
    
    public func setUpPrize(pizeImage: UIImage) {
        self.prizeImageView.image = pizeImage
    }
}

extension ScratchCardContainer: ScratchCardDelegate {

    public func scratchBegan(point: CGPoint) {
        print("start：\(point)")
    }
    
    public func scratchMoved(progress: Float) {
        print("progress：\(progress)")
        
        if progress > 0.70 {
            self.activateAnimation()
        }
        //let percent = String(format: "%.1f", progress * 100)
        //label.text = "\(percent)%"
    }
    
    public func scratchEnded(point: CGPoint) {
        print("stop：\(point)")
    }
    private func activateAnimation() {
        if !displayed {
            displayed = true
            self.hidePrize()
            self.showPrize()
        }
    }
    
    private func showPrize() {
        //print("prizeImageView: \(self.frame.height)")
        
        //print("prizeImageView: \(self.prizeImageView.frame.origin.y)")
        UIView.animate(withDuration: 1, animations: {
            self.prizeImageView.frame.origin.y = self.frame.height - 180
            self.scratchCardContainerDelegate?.getPrize!()
        })
    }
    
    private func hidePrize() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.prizeImageView.frame.origin.y = self.frame.height + 90
        })
    }
}

