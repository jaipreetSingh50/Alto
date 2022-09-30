//
//  Blur.swift
//  EatDigger
//
//  Created by Ramneet Singh on 03/05/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import UIKit


class customBlurView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customBlurEffect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customBlurEffect()
    }
    
    private func customBlurEffect() {

        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bounds
        blurEffectView.alpha = 0.4
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
        
    }
    
}

    class RoundBottomCornerView: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            customCorner()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            customCorner()
        }
        private func customCorner() {
            let maskPAth = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners: [.topLeft , .topRight],
                                        cornerRadii:CGSize(width: 30, height:30))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPAth.cgPath
            self.layer.mask = maskLayer
        }
    }

