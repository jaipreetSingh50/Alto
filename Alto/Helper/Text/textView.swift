//
//  textView.swift
//  PinBy
//
//  Created by Jaypreet on 03/07/20.
//  Copyright © 2020 Jaipreet. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift


class appTextField: UITextField {


    func setText()  {
        placeholder = ""
        attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
     attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setText()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setText()
    }
  

}

@available(iOS 13.0, *)
class TextView: UIView  , UIPickerViewDelegate , UIPickerViewDataSource{

    
    @IBInspectable var border : CGColor = CGColor.init(srgbRed: 192/255, green: 204/255, blue: 218/255, alpha: 1){
        didSet {
            updateColor()
        }
    }
    @IBInspectable var selectedborder : CGColor = CGColor.init(srgbRed: 0/255, green: 93/255, blue: 242/255, alpha: 1){
        didSet {
            updateColor()
        }
    }
    @IBInspectable var textFieldBgColor : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1){
        didSet {
            updateColor()
        }
    }
    @IBInspectable var text_Color : UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1){
         didSet {
             updateColor()
         }
     }
    @IBInspectable var isDropDown : Bool = false{
        didSet {
            updateColor()
        }
    }
    @IBInspectable var isEmail : Bool = false{
        didSet {
            updateColor()
        }
    }
    @IBInspectable var isPhone : Bool = false{
        didSet {
            updateColor()
        }
    }
    @IBInspectable var isCountryCode : Bool = false{
         didSet {
             updateColor()
         }
     }

    @IBInspectable var secureTextKey : Bool = false{
        didSet {
            updateColor()
        }
    }
    @IBInspectable var textPlaceholder : String = ""{
        didSet {
            settextfield()
        }
    }
    
    var t : UITextField!
    var c : UITextField!
    var Line : UILabel!

    var placeholderLable : UILabel!
    var innerView : UIView!
    var btnScure : UIButton!
    
    var countryDictionary = [String]()


    required init(coder aDecoder: (NSCoder?)) {
          super.init(coder: aDecoder!)!
        Setup()
    }
    func Setup()  {
         
        backgroundColor = UIColor.clear
        innerView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: frame.size.width - 4, height: frame.size.height - 12))
        addSubview(innerView)
        t = UITextField.init(frame: CGRect.init(x: 58, y: 8, width: innerView.frame.size.width - 68, height: innerView.frame.size.height - 12))
        c = UITextField.init(frame: CGRect.init(x: 8, y: 8, width: 42, height: innerView.frame.size.height - 12))
        c.placeholder = "Code"
        c.font = UIFont.textStyle
        c.textColor = UIColor.black
        c.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        c.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        c.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        let thePicker = UIPickerView()
        thePicker.delegate = self
        thePicker.dataSource = self

        c.inputView = thePicker
        innerView.addSubview(c)
        Line = UILabel.init(frame: CGRect.init(x: 54, y: 2, width: 0.5, height: 16))
        Line.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        Line.text = ""
        innerView.addSubview(Line)

       
        
        t.placeholder = textPlaceholder
        placeholderLable = UILabel.init(frame: CGRect.init(x: 20, y: 2, width: textPlaceholder.width(withConstrainedHeight: 16, font: UIFont.textStyle) + 4, height: 20))
        placeholderLable.backgroundColor = UIColor.clear
        placeholderLable.font = UIFont.textStyle
        addSubview(placeholderLable)
        placeholderLable.textAlignment = .center
        innerView.addSubview(t)
        placeholderLable.isHidden = true
        t.font = UIFont.textStyle
        t.textColor = UIColor.black
        t.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        t.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        t.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        btnScure = UIButton.init(frame: CGRect.init(x: frame.size.width - 30, y: frame.size.height/2 - 10, width: 20, height: 20))
        btnScure.addTarget(self, action: #selector(eyePassword(_:)), for: .touchDown)
        btnScure.setImage(#imageLiteral(resourceName: "ic_eye"), for: .normal)
        innerView.addSubview(btnScure)
        
        countryDictionary = Constants.countryDictionary.allKeys as! [String]
        countryDictionary.sort()
        

    }
    func UpdateFrame()  {
        innerView.frame = CGRect.init(x: 0, y: 10, width: frame.size.width , height: frame.size.height - 12)
        
        if isCountryCode{
            t.frame =  CGRect.init(x: 58, y: 8, width: innerView.frame.size.width - 60, height: innerView.frame.size.height - 12)
            c.frame =  CGRect.init(x: 8, y: 8, width: 42, height: innerView.frame.size.height - 12)
            Line.frame =  CGRect.init(x: 54, y: 8, width: 0.5, height:  innerView.frame.size.height - 16)

        }
        else{
            c.removeFromSuperview()
            Line.removeFromSuperview()
            t.frame =  CGRect.init(x: 8, y: 8, width: innerView.frame.size.width - 12, height: innerView.frame.size.height - 12)

        }
        
        placeholderLable.frame =  CGRect.init(x: 15, y: 2, width: textPlaceholder.width(withConstrainedHeight: 16, font: UIFont.textStyle) + 8, height: 16)
        btnScure.frame =  CGRect.init(x: frame.size.width - 30, y: t.frame.size.height/2 - 6, width: 20, height: 20)


    }
    func updateColor() {

        innerView.layer.cornerRadius = 4
        innerView.backgroundColor = textFieldBgColor
        t.isSecureTextEntry = secureTextKey
        t.textColor = text_Color
        placeholderLable.textColor = text_Color
        if isPhone{
            
            t.keyboardType = .phonePad
        }
//        if isCountryCode {
//
//        }
//        else{
//
//        }
        if isEmail{
            t.keyboardType = .emailAddress
        }
        if secureTextKey{
            btnScure.isHidden = false
        }
        else{
            btnScure.isHidden = true
        }
        if isDropDown{
            btnScure.isHidden = false
            btnScure.setImage(#imageLiteral(resourceName: "arrow_dropdown"), for: .normal)
            btnScure.isUserInteractionEnabled = false
        }
        
      
     }
    func settextfield() {
        t.placeholder = textPlaceholder
        c.placeholder = "Code"

     }
    @objc func textFieldDidChange(_ textField: UITextField) {
        SetPosition()
    }
    func SetPosition()  {
       
        if t.text == ""{
            placeholderLable.isHidden = true
            placeholderLable.text = t.placeholder
            innerView.layer.borderColor = (border )
        }
        else{
            placeholderLable.isHidden = false
            placeholderLable.text = t.placeholder
            innerView.layer.borderColor = (selectedborder )
        }
    }
    @IBAction func eyePassword(_ sender: UIButton) {
        if isDropDown{
                   return
               }
          if btnScure.image(for: .normal) == #imageLiteral(resourceName: "ic_eye"){
                   t.isSecureTextEntry = false
                   btnScure.setImage(#imageLiteral(resourceName: "ic_hide_eye"), for: .normal)
               }
               else{
                   t.isSecureTextEntry = true
                    btnScure.setImage(#imageLiteral(resourceName: "ic_eye"), for: .normal)
               }
      }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryDictionary.count

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryDictionary[row] + " : \(Constants.countryDictionary[countryDictionary[row]] ?? "")"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        c.text = Constants.countryDictionary[countryDictionary[row]] as? String
    }
    
}
@available(iOS 13.0, *)
class TextTextView: UIView , UITextViewDelegate {
    @IBInspectable var border : CGColor = CGColor.init(srgbRed: 192/255, green: 204/255, blue: 218/255, alpha: 1){
        didSet {
            updateColor()
        }
    }
    @IBInspectable var selectedborder : CGColor = CGColor.init(srgbRed: 0/255, green: 93/255, blue: 242/255, alpha: 1){
        didSet {
            updateColor()
        }
    }
    @IBInspectable var textFieldBgColor : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1){
        didSet {
//            updateColor()
        }
    }

    

 
    @IBInspectable var textPlaceholder : String = ""{
        didSet {
            settextfield()
            UpdateFrame()
        }
    }
    @IBInspectable var textTitle : String = ""{
        didSet {
            settextfield()
            UpdateFrame()
        }
    }
    
    var t : IQTextView!
    var placeholderLable : UILabel!
    var innerView : UIView!

    required init(coder aDecoder: (NSCoder?)) {
          super.init(coder: aDecoder!)!
        Setup()
    }
    func Setup()  {
         

        backgroundColor = UIColor.clear
        innerView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: frame.size.width - 4, height: frame.size.height - 12))
        addSubview(innerView)
        
        t = IQTextView.init(frame: CGRect.init(x: 8, y: 8, width: innerView.frame.size.width - 30, height: innerView.frame.size.height - 16))
        t.placeholder = textPlaceholder
        placeholderLable = UILabel.init(frame: CGRect.init(x: 20, y: 2, width: textPlaceholder.width(withConstrainedHeight: 16, font: UIFont.textStyle) + 4, height: 16))
        placeholderLable.font = UIFont.textStyle
        addSubview(placeholderLable)
        placeholderLable.textAlignment = .center
        placeholderLable.backgroundColor = UIColor.white
       
        innerView.addSubview(t)
        placeholderLable.isHidden = true

        t.font = UIFont.textStyle
        t.textColor = UIColor.black
        t.delegate = self
        
        updateColor()
        

        
    }
    func UpdateFrame()  {
        innerView.frame = CGRect.init(x: 0, y: 10, width: frame.size.width , height: frame.size.height - 12)
        t.frame =  CGRect.init(x: 8, y: 0, width: innerView.frame.size.width - 12, height: innerView.frame.size.height - 2)
        placeholderLable.frame =  CGRect.init(x: 15, y: 2, width: textTitle.width(withConstrainedHeight: 16, font: UIFont.textStyle) + 8, height: 16)


    }
    func updateColor() {
//        Setup()
        innerView.layer.borderColor = (border )
        innerView.layer.cornerRadius = 4
        innerView.layer.borderWidth = 1
        innerView.backgroundColor = textFieldBgColor
        
        
      
     }
    func settextfield() {
        t.placeholder = textPlaceholder
     }
    func textViewDidChange(_ textView: UITextView) {
        SetPosition()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
   
    func SetPosition()  {
       
        if t.text == ""{
            placeholderLable.isHidden = true
            placeholderLable.text = textTitle
            innerView.layer.borderColor = (border )
        }
        else{
            placeholderLable.isHidden = false
            placeholderLable.text = textTitle
            innerView.layer.borderColor = (selectedborder )
        }
    }

    
    
}
