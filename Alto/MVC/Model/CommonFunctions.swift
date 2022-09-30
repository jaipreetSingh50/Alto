


//
//  CommonFunctions.swift
//  FitTest
//
//  Created by Jaypreet on 14/11/19.
//  Copyright © 2019 Jaypreet. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AVFoundation
import AVKit
import SDWebImage
import MobileCoreServices


extension UIViewController  : AVAudioPlayerDelegate , AVCaptureAudioDataOutputSampleBufferDelegate{
    

    
    
    
    
    
    
    
 
    func blurEffect(image : UIImage)  -> UIImage{
        var context = CIContext(options: nil)

        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }

   

}

extension UIImageView {
    func getImage(url : String , isUser : Bool = false)  {
        
        
        
        if isUser{
            if url.isValidURL{
                return self.sd_setImage(with: URL.init(string:  url), placeholderImage: #imageLiteral(resourceName: "deafult_user"))
            }
            return self.sd_setImage(with: URL.init(string: Constants.API.IMAGE_BASE_URL + url), placeholderImage: #imageLiteral(resourceName: "deafult_user"))

        }
        if url.isValidURL{
            return self.sd_setImage(with: URL.init(string:  url), placeholderImage: #imageLiteral(resourceName: "deafult_user"))

        }
        return self.sd_setImage(with: URL.init(string: Constants.API.IMAGE_BASE_URL + url), placeholderImage: #imageLiteral(resourceName: "deafult_user"))

    }
}


extension String {

    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    func SetLang() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    func SetGender() -> String {
        if self == "1"{
            return "Male"
        }
        if self == "2"{
            return "Female"
        }
        return "-"
    }
    
    var containsSpecialCharacter: Bool {
       let regex = ".*[^A-Za-z0-9- ].*"
       let testString = NSPredicate(format:"SELF MATCHES %@", regex)
       return testString.evaluate(with: self)
    }

    
    func attributedStringWithColor( color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let abc:[String] =  (self.components(separatedBy: " ").filter({ $0.range(of: "@", options: NSString.CompareOptions.caseInsensitive , range: nil, locale: nil) != nil } ))

        return self.attributedStringWithColor(abc, color: color)
    }
    
    
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let attributes = [NSAttributedString.Key.font : UIFont.init(name: SystemFont.FontFamilyNameBold, size: 20)]

        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            attributedString.addAttributes(attributes as [NSAttributedString.Key : Any], range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length) )
        attributedString.addAttributes(attributes as [NSAttributedString.Key : Any],  range: NSRange(location: 0, length: attributedString.length))


        return attributedString
    }
}


class CommonFunctions: NSObject {
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+?><|?"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[A-Z])(?=.*[!@#$%^&*()_+?><|?])(?=.*[0-9])(?=.*[a-z]).{8,}$")
        
        var text = ""

        
        repeat {
             text = String((0..<length).map{ _ in letters.randomElement()! })
            print(text)
            //take input from standard IO into variable n
        } while !passwordTest.evaluate(with: text)

        return text

        
      
        
        
        
    }
    

    
    func GetStringFormJson(value : Any) -> String {
        
                if value is String{
                    return value as! String
                }
                
                if value is NSNumber{
                    if "\(value)".contains(".") {
                        return  String(format: "%.2f", value as! Double)
                    }
                    
                    return  "\(value)"
                }
                return ""
        }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func convertIntoJSONString(arrayObject: [Any]) -> String? {
        var JsonCreate : String = ""

        if let objectData = try? JSONSerialization.data(withJSONObject: arrayObject, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            JsonCreate = objectString!
        }
        
        print(JsonCreate)
        return JsonCreate

  
    }
    func convertJSONToObject(arrayObject: String) -> [String : Any] {
        
        let data = arrayObject.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : []) as? [String : Any]
            {
               print(jsonArray) // use the json here
                return jsonArray as [String : Any]
            } else {
                print("bad json")
                return [:]
            }
        } catch let error as NSError {
            print(error)
            return [:]
        }
      }
    func convertJSONToArray(arrayObject: String) -> [[String : Any]] {
        
        let data = arrayObject.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : []) as? [[String : Any]]
            {
               print(jsonArray) // use the json here
                return jsonArray as [[String : Any]]
            } else {
                print("bad json")
                return []
            }
        } catch let error as NSError {
            print(error)
            return []
        }
      }

}

class CountryCodeForPhoneNumber  {
   static func getCurrentCountryCode() -> String {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            return countryCode
        }
        return "IN"
    }
}
typealias  textFieldCountryCodePickerConfigureBlock = (_ text : String , _ Index : Int? ) -> ()


class TextFieldCountryCodePickerController  : NSObject ,  UIPickerViewDelegate, UIPickerViewDataSource{
    var Picker = UIPickerView()
    var configureCellBlock : textFieldCountryCodePickerConfigureBlock?
    var viewController : UIViewController!
    var sender : UITextField!
    var countryDictionary = [String]()
    
    init (picker : UIPickerView? , viewController : UIViewController? , sender : UITextField? , configureCellBlock : textFieldPickerConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        self.sender.inputView = self.Picker
        super.init()
        self.countryDictionary = Constants.countryDictionary.allKeys as! [String]

        self.Picker.dataSource = self
        self.Picker.delegate = self
        self.Picker.reloadAllComponents()
        if countryDictionary.count != 0{
            if let block = self.configureCellBlock {
                block("\(Constants.countryDictionary[countryDictionary[0]] as! String)" , 0)
            }
        }
    }
    
    override init() {
        super.init()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return countryDictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return   "\(countryDictionary[row]) : \(Constants.countryDictionary[countryDictionary[row]] as! String)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
            if let block = self.configureCellBlock {
                block("\(Constants.countryDictionary[countryDictionary[row]] as! String)" , row)
            }
    }
}

typealias  returnImageConfigureBlock = (_ image : UIImage , _ path : String? ) -> ()

enum PickerType {
    case Camera
    case Gallery
    case Both
    
    func Get() -> String {
        switch self {
            
        case .Camera : return "1"
        case .Gallery : return "2"
        case .Both : return "3"

            
        }
        
    }
 

}

class ImageController  : NSObject , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var imagePicker = UIImagePickerController()
    var configureCellBlock : returnImageConfigureBlock?
    var viewController : UIViewController!
    var sender : UIButton!

    init ( viewController : UIViewController? , type : String , sender : UIButton? , configureCellBlock : returnImageConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        super.init()

        if type == PickerType.Camera.Get(){
            self.openCamera()
        }
        else if type == PickerType.Gallery.Get(){
            self.openGallary()
        }
        else if type == PickerType.Both.Get(){
            AskForImageUpload(sender: sender!)

        }
    }
    
    override init() {
        super.init()
    }
    
    func AskForImageUpload(sender : UIButton)  {

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        viewController.AskPromission(type: .Camera) { (vi, status) in
            if !status{
                return
            }
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.delegate = self
                self.viewController.present(self.imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.viewController.present(alert, animated: true, completion: nil)
            }
        }
    
    }
    
    func openGallary()
    {
        viewController.AskPromission(type: .Gallery) { (view, status) in
            if !status{
                return
            }
            DispatchQueue.main.async {

                self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.imagePicker.allowsEditing = true
                self.imagePicker.delegate = self
                
                self.viewController.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
          
               
            if let block = self.configureCellBlock {
                block(editedImage ,  (info[UIImagePickerController.InfoKey.imageURL] as? URL)?.absoluteString)
            }
        }
        else if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if let block = self.configureCellBlock {
                block(editedImage ,  (info[UIImagePickerController.InfoKey.imageURL] as? URL)?.absoluteString)
            }
        }
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true) {
            //            self.UploadProfilePic()
        }
    }
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        viewController.dismiss(animated: true, completion: nil)
    }
}

typealias  returnVideoConfigureBlock = (_ image : URL , _ path : String? ) -> ()


class videoController  : NSObject , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    var configureCellBlock : returnVideoConfigureBlock?
    var viewController : UIViewController!
    var sender : UIButton!

    init ( viewController : UIViewController? , sender : UIButton? , configureCellBlock : returnVideoConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        super.init()

        AskForImageUpload(sender: sender!)
    }
    
    override init() {
        super.init()
    }
    
    func AskForImageUpload(sender : UIButton)  {

        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if let block = self.configureCellBlock {
                block(URL.init(string: "Camera")! ,  "Camera")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.mediaTypes = [ "public.movie"]

            imagePicker.delegate = self
            viewController.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.mediaTypes = [ "public.movie"]

        viewController.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
            if let block = self.configureCellBlock {
                block((info[UIImagePickerController.InfoKey.mediaURL] as? URL)! ,  (info[UIImagePickerController.InfoKey.mediaURL] as? URL)?.absoluteString)
            }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true) {
            //            self.UploadProfilePic()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        viewController.dismiss(animated: true, completion: nil)
    }
}


typealias  textFieldPickerConfigureBlock = (_ text : String , _ Index : Int? ) -> ()


class TextFieldPickerController  : NSObject ,  UIPickerViewDelegate, UIPickerViewDataSource{
    var Picker = UIPickerView()
    var configureCellBlock : textFieldPickerConfigureBlock?
    var viewController : UIViewController!
    var sender : UITextField!
    var countryDictionary = [String]()
    
    init (array : [String] ,picker : UIPickerView? , viewController : UIViewController? , sender : UITextField? , configureCellBlock : textFieldPickerConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        self.sender.inputView = self.Picker
        super.init()
        self.countryDictionary = array

        self.Picker.dataSource = self
        self.Picker.delegate = self
      
        self.Picker.reloadAllComponents()
        if countryDictionary.count != 0{
            if let block = self.configureCellBlock {
                block(countryDictionary[0] , 0)
            }
        }
    }
    
    override init() {
        super.init()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return countryDictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryDictionary[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
            if let block = self.configureCellBlock {
                block(countryDictionary[row] , row)
            }
    }
}

typealias  ActionPickerConfigureBlock = (_ text : [String] , _ Index : Int? , _ Status : String?  ) -> ()


class ActionPickerController  : NSObject ,  UIPickerViewDelegate, UIPickerViewDataSource{
    var Picker = UIPickerView()
    var configureCellBlock : ActionPickerConfigureBlock?
    var viewController : UIViewController!
    var sender : Any!
    var Dictionary = [[String]]()
    var TitlePicker : String = ""
    var SelectedTitle : String = ""
    var Index : Int = 0
    var tempDictionary = [String]()

    
    
    
    var bgView : UIView!
    init (array : [[String]], title : String  ,picker : UIPickerView? , viewController : UIViewController? , sender : Any? , configureCellBlock : ActionPickerConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        self.TitlePicker = title
        super.init()
        self.Dictionary = array
        SelectedTitle = array[0][Index]
        for i in  array{
            if i.count != 0{
                tempDictionary.append(i[0])
            }
        }
        CreateView()

    }
    func CreateView()  {
        bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        bgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3395494435)
        
        
        let pickerView = UIView.init(frame: CGRect.init(x: 20, y: (UIScreen.main.bounds.height/2 - (UIScreen.main.bounds.width - 40)/2) - 80, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 100))
        pickerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pickerView.layer.cornerRadius = 6
        pickerView.clipsToBounds = true
        let stact = UIStackView.init(frame: CGRect.init(x: 20, y: pickerView.bounds.height - 70, width: pickerView.bounds.width - 40, height: 50))
        stact.axis = .horizontal
        stact.alignment = .fill
        stact.distribution = .fillEqually
        stact.spacing = 20
        
        let cancel = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: pickerView.bounds.width/2, height: 45))
        cancel.setTitle("CANCEL", for: .normal)
        cancel.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
//        cancel.titleLabel!.font = UIFont(name: SystemFont.FontFamilyName, size: 15)
        cancel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cancel.layer.cornerRadius = 6
        if #available(iOS 13.0, *) {
            cancel.layer.borderColor = CGColor.init(srgbRed: 192/255, green: 204/255, blue: 218/255, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
        cancel.layer.borderWidth = 1
        cancel.addTarget(self, action: #selector(CancelPicker), for: .touchDown)
        stact.addArrangedSubview(cancel)
        
        let Done = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: pickerView.bounds.width/2, height: 45))
        Done.setTitle("DONE", for: .normal)
        Done.setTitleColor(#colorLiteral(red: 0.7900810838, green: 0.6154652238, blue: 0, alpha: 1), for: .normal)
        Done.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Done.layer.cornerRadius = 6
//        Done.titleLabel!.font = UIFont(name: SystemFont.FontFamilyName, size: 15)


        Done.addTarget(self, action: #selector(DonePicker), for: .touchDown)

        stact.addArrangedSubview(Done)
        
        let Title  = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: pickerView.bounds.width, height: 65))
        Title.text = TitlePicker
        Title.textAlignment = .center
//        Title.font = UIFont.init(name: SystemFont.FontFamilyNameBold, size: 17)
        Title.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        Title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Title.layer.masksToBounds = true
        Title.clipsToBounds = true

        let line  = UILabel.init(frame: CGRect.init(x: 0, y: 45, width: pickerView.bounds.width, height: 1))
        line.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        Picker = UIPickerView.init(frame: CGRect.init(x: 0, y: 45, width: pickerView.bounds.width, height: (UIScreen.main.bounds.width - 120) - 90))
        self.Picker.dataSource = self
        self.Picker.delegate = self
        self.Picker.reloadAllComponents()
        for (i, value) in tempDictionary.enumerated(){
            if self.sender is UITextField{
                if value == (self.sender as! UITextField).text!{
                    self.Picker.selectRow(i, inComponent: 0, animated: false)
                }
            }
        }

        pickerView.addSubview(stact)
        pickerView.addSubview(Title)
        pickerView.addSubview(Picker)
//        pickerView.addSubview(line)

        bgView.addSubview(pickerView)
        self.viewController.view.addSubview(bgView)
    }
    @objc func CancelPicker()  {
        bgView.removeFromSuperview()
        if let block = self.configureCellBlock {
            block([""] , 0, "close")
        }
       
    }
    @objc func DonePicker()  {
        bgView.removeFromSuperview()
        
        if let block = self.configureCellBlock {
            block(tempDictionary , Index, "Done")
        }

    }
    override init() {
        super.init()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Dictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return Dictionary[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Dictionary[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        tempDictionary[component] = Dictionary[component][row]
        Index = row
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
//            pickerLabel?.font = UIFont(name: SystemFont.FontFamilyName, size: 20)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Dictionary[component][row]
        pickerLabel?.textColor = UIColor.black
        return pickerLabel!
    }
}

typealias  ActionTextFieldPickerConfigureBlock = (_ text : [String] , _ Index : Int? , _ Status : String?  ) -> ()


class ActionTextFieldPickerController  : NSObject ,  UIPickerViewDelegate, UIPickerViewDataSource{
    var Picker = UIPickerView()
    var configureCellBlock : ActionPickerConfigureBlock?
    var viewController : UIViewController!
    var sender : UITextField!
    var Dictionary = [[String]]()
    var TitlePicker : String = ""
    var SelectedTitle : String = ""
    var Index : Int = 0
    var tempDictionary = [String]()
    
    
    
    
    var bgView : UIView!
    init (array : [[String]], title : String ,picker : UIPickerView? , viewController : UIViewController? , sender : UITextField? , configureCellBlock : ActionTextFieldPickerConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        self.TitlePicker = title
        super.init()
        self.Dictionary = array
        SelectedTitle = array[0][Index]
        self.sender.inputView = self.Picker
        self.Picker.dataSource = self
        self.Picker.delegate = self
        self.Picker.reloadAllComponents()
        for i in  array{
            tempDictionary.append(i[0])
        }
    }
  
    override init() {
        super.init()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Dictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return Dictionary[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Dictionary[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        tempDictionary[component] = Dictionary[component][row]
        Index = row
        if let block = self.configureCellBlock {
            block(tempDictionary , Index, "Done")
        }
    }
}

typealias  dateTextFieldPickerConfigureBlock = (_ text : String , _ date : Date? ) -> ()


class dateTextFieldPickerController  : NSObject{
    var Picker = UIDatePicker()
    var configureCellBlock : dateTextFieldPickerConfigureBlock?
    var viewController : UIViewController!
    var sender : UITextField!
    var format : String = "MM/dd/yyyy hh:mm a"

    init (format : String ,lastDatedSelected : Date , MinDate : Date ,  MaxDate : Date , mode : UIDatePicker.Mode , viewController : UIViewController? , sender : UITextField? , configureCellBlock : dateTextFieldPickerConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        self.format = format

        self.Picker.maximumDate = MaxDate
        self.Picker.minimumDate = MinDate
        self.Picker.date = lastDatedSelected
        self.Picker.datePickerMode = mode
        if #available(iOS 14.0, *) {
            self.Picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        self.sender.inputView = self.Picker
        
        super.init()
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = format
        let selectedDate: String = dateFormatter.string(from: lastDatedSelected)
        if let block = self.configureCellBlock {
            block(selectedDate , lastDatedSelected)
        }
        
        
        self.Picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    override init() {
        super.init()
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = format
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        if let block = self.configureCellBlock {
            block(selectedDate , sender.date)
        }
    }
    
    
}

class ActionCollectionCell: UICollectionViewCell {

    static var identifier: String = "ActionCollectionCell"

    weak var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
        ])
        self.textLabel = textLabel
        self.reset()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }

    func reset() {
        self.textLabel.textAlignment = .center
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1.2
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
           green: .random(in: 0...1),
           blue:  .random(in: 0...1),
           alpha: 1.0
        )
    }
}
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}


typealias  returnDocumentConfigureBlock = (_ path : String?,_ data : Data ) -> ()

class DocumentController  : NSObject , UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    var imagePicker = UIImagePickerController()
    var configureCellBlock : returnDocumentConfigureBlock?
    var viewController : UIViewController!
    var sender : UIButton!

    init ( viewController : UIViewController? , type : String , sender : UIButton? , configureCellBlock : returnDocumentConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        super.init()

       
        AskForImageUpload(sender: sender!)

        
    }
    
    override init() {
        super.init()
    }
    
    func AskForImageUpload(sender : UIButton)  {
        let documentProvider =  UIDocumentPickerViewController(documentTypes: ["public.image", "public.text", "public.item", "public.content", "public.source-code"], in: .import)
        documentProvider.delegate = self
        documentProvider.modalPresentationStyle = .formSheet
        if let popoverPresentationController = documentProvider.popoverPresentationController {
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = sender.bounds
        }
        viewController.present(documentProvider, animated: true, completion: nil)
     
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        if let block = self.configureCellBlock {
            let fileData = NSData(contentsOf: myURL)
            let fileManager = FileManager.default
            

            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            var documentsDirectory = paths[0]
            documentsDirectory = NSTemporaryDirectory()
            let docURL = URL.init(fileURLWithPath: documentsDirectory)
            let dataPath = docURL.appendingPathComponent("\(Int(NSDate().timeIntervalSince1970)).MOV")
            if !FileManager.default.fileExists(atPath: dataPath.relativePath) {
                do {
                    try FileManager.default.createDirectory(atPath: dataPath.relativePath, withIntermediateDirectories: true, attributes: nil)
                    if (fileManager.fileExists(atPath: dataPath.relativePath)) {
                        print(true)
                    }
                    
                    block(  myURL.absoluteString , fileData! as Data)

                    

                    
                } catch {
                    print(error.localizedDescription)
                }
            }

            
            
            
        }
        print("import result : \(myURL)")
    }
          

    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        viewController.present(documentPicker, animated: true, completion: nil)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        viewController.dismiss(animated: true, completion: nil)
    }
}
