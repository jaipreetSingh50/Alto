//
//  ListPicker.swift
//  FitTest
//
//  Created by Jaypreet on 13/11/19.
//  Copyright © 2019 Jaypreet. All rights reserved.
//

import Foundation
import UIKit



class ListPicker : NSObject , UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var myPickerData = [String](arrayLiteral: "Peter", "Jane", "Paul", "Mary", "Kevin", "Lucy")
    var mainView = UIView()
    var Controller = UIViewController()
    
    func SetUp(viewController : UIViewController , title : String , Data : [String] )  {
        Controller = viewController
         mainView = UIView.init(frame:  CGRect.init(x: 0 , y: 0, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.height)))
        mainView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.301557149)
        mainView.alpha = 1
        
        let innerView = UIView.init(frame:  CGRect.init(x: 20 , y: Int(UIScreen.main.bounds.height/2 - 200), width: Int(UIScreen.main.bounds.width - 40), height: Int(300)))
        innerView.backgroundColor = UIColor.white
        innerView.alpha = 0
        innerView.alpha = 1
        
        let stackButton = UIStackView.init(frame: CGRect.init(x: 0 , y: Int(0), width: Int(UIScreen.main.bounds.width - 40), height: Int(50)))
        
        stackButton.axis = .horizontal
        stackButton.alignment = .fill
        stackButton.distribution = .fillEqually
        stackButton.spacing = 0
        let Cancel = UIButton.init(frame: CGRect.init(x: 0 , y: Int(0), width: Int(UIScreen.main.bounds.width - 40)/2, height: Int(50)))
        Cancel.setTitle("Cancel", for: .normal)
        Cancel.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Cancel.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        Cancel.addTarget(self, action: #selector(self.cancelTapped(_:)), for: .touchDown)

        
        stackButton.addArrangedSubview(Cancel)
        
        let Done = UIButton.init(frame: CGRect.init(x: 0 , y: Int(0), width: Int(UIScreen.main.bounds.width - 40)/2, height: Int(50)))
        Done.setTitle("Done", for: .normal)
        Done.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Done.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        Done.addTarget(self, action: #selector(self.doneTapped(_:)), for: .touchDown)

        stackButton.addArrangedSubview(Done)
        
//        myPickerData = Data
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRect.init(x: 0 , y: Int( 50), width: Int(UIScreen.main.bounds.width - 40), height: Int(200)))
        picker.backgroundColor = .white
        
//        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = #colorLiteral(red: 0.8822031617, green: 0.7986294578, blue: 0.145895762, alpha: 1)
        
        
     
        
        
        innerView.addSubview(picker)

        innerView.addSubview(stackButton)
        mainView.addSubview(innerView)

        
        
        
        viewController.view.addSubview(mainView)
    }
    
    @objc func doneTapped(_ sender : UIButton) {
        mainView.removeFromSuperview()

    }
    
    @objc func cancelTapped(_ sender : UIButton) {
        mainView.removeFromSuperview()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
}
