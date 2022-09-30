//
//  ButtonsExtClasses.swift
//  EatDigger
//
//  Created by Ramneet Singh on 07/05/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import UIKit

extension UIButton {
    
    func springAnimateButton(complition: @escaping ((Bool) -> Void) ) {
        
     self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    
    UIView.animate(withDuration: 2.0,
    delay: 0,
    usingSpringWithDamping: CGFloat(0.20),
    initialSpringVelocity: CGFloat(6.0),
    options: UIView.AnimationOptions.allowUserInteraction,
    animations: {
    self.transform = CGAffineTransform.identity
    complition(true)
    },
    completion: { Void in()  }
    )
       
    }
  
    
    
    func pressAnimation(completion:@escaping ((Bool) -> Void)) {
        
        UIView.animate(withDuration: 0.05, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) }, completion: { (finish: Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform.identity
                    
                    completion(finish)
                })
        })
        
    }
    
    
    
    func pulsateRegular() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func pulsateFast() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 5
        pulse.damping = 4.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    
    func flashButton() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shakeButton() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
    func SetColorImage(color : UIColor) {
        let origImage = self.image(for: .normal)
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
    func SetColorBackgroundImage(color : UIColor) {
        let origImage = self.backgroundImage(for: .normal)
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.setBackgroundImage(tintedImage, for: .normal)
        self.tintColor = color
    }
    func SetColorImage(color : UIColor , state : UIControl.State) {
        let origImage = self.image(for: state)
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.setImage(tintedImage, for: state)
        self.tintColor = color
    }
}


