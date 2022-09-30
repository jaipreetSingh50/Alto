//
//  RoundButtonClass.swift
//  EatDigger
//
//  Created by Ramneet Singh on 03/05/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//
import UIKit


//MARK:- RoundBottomCornerButtonClass: UIButton
class RoundBottomCornerButtonClass: UIButton {
    
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
                                    byRoundingCorners: [.bottomLeft , .bottomRight],
                                    cornerRadii:CGSize(width: self.frame.size.height/2, height:0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPAth.cgPath
        self.layer.mask = maskLayer
    }
}


//MARK:- RoundBottomCornerButtonClass: UIButton
class RoundTopCornerButtonClass: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        customCorner()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   
        customCorner()
    }
    private func customCorner() {
        
        let rect = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: UIScreen.main.bounds.width, height: frame.size.height)
        let maskPAth = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii:CGSize(width: 30, height:0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPAth.cgPath
        self.layer.mask = maskLayer
    }
}


//MARK:- RoundBottomCornerButtonClass: UIButton
class RoundCornerAndShadowButtonClass: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.height/2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.gray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
}

//MARK:- RoundCornerButtonClass: UIButton
class RoundCornerButton: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
       self.cornerRadius = self.frame.size.height/2
    }
    
}

//MARK:- RoundCornerButtonClass: UIButton
class RoundCornerButtonClass: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.height/2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.contentsAreFlipped()
            
            layer.insertSublayer(shadowLayer, at: 0)
            layer.contentsAreFlipped()
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
}



//MARK:- RoundCorner_Blue_ButtonClass: UIButton
class RoundCorner_Blue_Shade_ButtonClass: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.height/2).cgPath
            shadowLayer.fillColor = UIColor.blue.cgColor
            
            shadowLayer.shadowColor = UIColor.gray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            layer.insertSublayer(shadowLayer, at: 0)
            
        }
    }
    
}



//MARK:- RoundCorner_Blue_ButtonClass: UIButton
class RoundCorner_White_Shade_ButtonClass: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.height/2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.gray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            layer.insertSublayer(shadowLayer, at: 0)
            
        }
    }
    
}






//MARK:- RoundCorner5_Theme_Shade_ButtonClass: UIButton
class RoundCorner5_Theme_Shade_ButtonClass: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.height/2).cgPath
            shadowLayer.fillColor = UIColor.main_Theme_Color().cgColor
            
            shadowLayer.shadowColor = UIColor.gray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            layer.insertSublayer(shadowLayer, at: 0)
            
        }
    }
    
}
extension UIImageView {
    func corner()  {
        let maskPAth = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft , .bottomRight],
                                    cornerRadii:CGSize(width: 50, height:0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPAth.cgPath
        self.layer.mask = maskLayer
    }
}


