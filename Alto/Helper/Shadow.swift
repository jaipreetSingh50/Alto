//
//  Shadow.swift
//  EatDigger
//
//  Created by Ramneet Singh on 03/05/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import UIKit

class ShadowToView: UIView {
    
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 7.0
        self.layer.masksToBounds = false
    }
}


class ShadowToButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 3.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowColor = UIColor.green.cgColor
        self.layer.masksToBounds = false
    }
    
}
