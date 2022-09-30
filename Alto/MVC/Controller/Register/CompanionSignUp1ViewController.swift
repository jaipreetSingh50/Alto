//
//  CompanionSignUp1ViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit
import FlagPhoneNumber

class CompanionSignUp1ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: FPNTextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    var btnEye : UIButton!
    var btnEye2 : UIButton!

    @IBOutlet weak var lblAutoPassMsg: UILabel!

    @IBOutlet weak var btnSavePassword: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnEye = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 15))
        btnEye.setImage(#imageLiteral(resourceName: "ic_eye.png"), for: .normal)
        btnEye.setImage(#imageLiteral(resourceName: "ic_hide_eye.png"), for: .selected)
        txtConfirmPassword.rightView = btnEye
        txtConfirmPassword.rightViewMode = .always

        btnEye.addTarget(self, action: #selector(self.Password(_:)), for: .touchDown)
        btnSavePassword.setImage(#imageLiteral(resourceName: "ic_checkbox_normal"), for: .normal)
        btnSavePassword.setImage(#imageLiteral(resourceName: "ic_checkbox_selected"), for: .selected)
        btnSavePassword.isSelected = true
        
        
        btnEye2 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 15))
        btnEye2.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        btnEye2.setImage(#imageLiteral(resourceName: "ic_eye.png"), for: .normal)
        btnEye2.setImage(#imageLiteral(resourceName: "ic_hide_eye.png"), for: .selected)
        txtPassword.rightView = btnEye2
        txtPassword.rightViewMode = .always
        
        btnEye2.addTarget(self, action: #selector(self.Password2(_:)), for: .touchDown)
        
        txtPassword.textContentType = .newPassword
        txtConfirmPassword.textContentType = .newPassword
        txtUserName.textContentType = .username
        txtUserName.keyboardType = .emailAddress
        // Do any additional setup after loading the view.
    }
    @IBAction func SavePassword(_ sender: Any) {
         btnSavePassword.isSelected  = !btnSavePassword.isSelected
            
        
    }
    @IBAction func AutoPassword(_ sender: Any) {
        
        let txt = CommonFunctions().randomString(length: 12)
        txtPassword.text = txt
        txtConfirmPassword.text = txt
        self.txtConfirmPassword.isSecureTextEntry = false
        self.btnEye.isSelected = true
        
        self.txtPassword.isSecureTextEntry = false
        self.btnEye2.isSelected = true
        self.lblAutoPassMsg.isHidden = false
        lblAutoPassMsg.text = "« please write this password before pushing the button continue »"
        
    }
    @IBAction func Password(_ sender: UIButton) {
        self.btnEye.isSelected = !self.btnEye.isSelected
        if self.btnEye.isSelected{
            self.txtConfirmPassword.isSecureTextEntry = false
        }
        else{
            self.txtConfirmPassword.isSecureTextEntry = true

        }
    }
    @IBAction func Password2(_ sender: UIButton) {
        self.btnEye2.isSelected = !self.btnEye2.isSelected
        if self.btnEye2.isSelected{
            self.txtPassword.isSecureTextEntry = false
        }
        else{
            self.txtPassword.isSecureTextEntry = true

        }
    }

    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Continue(_ sender: Any) {
        if txtFirstName.CheckText() && txtLastName.CheckText() && txtLastName.CheckText() && txtPassword.CheckText(.PasswordCreate) && txtPassword.MatchPassword(txt: txtConfirmPassword) && txtPhone.CheckText(.PhoneNumber){
                
            let dict = ["first_name" : txtFirstName.text!,
                        "last_name" : txtLastName.text!,
                        "user_type" :  Int(DataManager.CurrentUserRole ?? "2") ?? 2,
                        "phone" : txtPhone.text!,
                        "country_code" : Int(((txtPhone.selectedCountry?.phoneCode ?? "+1") as String).replacingOccurrences(of: "+", with: "")) ?? 1 ,
                        "country_code_text" : txtPhone.selectedCountry?.code.rawValue as Any,
                        "user_name" : txtUserName.text!,
                        "email" : txtEmail.text!,

                        "password" : txtPassword.text!
            ] as [String : Any]
            
            APIClients.RegisterAndUpdateProfile(parems: dict , storyBoard: storyboard!, navigation: self) { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    Constants.Toast.MyToast(message: response.message ?? ""   )
                    DataManager.Auth_Token = response.token
                    if self.btnSavePassword.isSelected{
                        DataManager.CompanionRememberEmail = self.txtUserName.text!
                        DataManager.CompanionRememberPassword = self.txtPassword.text!
                    }
                    else{
                        DataManager.CompanionRememberEmail = ""
                        DataManager.CompanionRememberPassword = ""
                    }
                    if response.user.other_data?.preferred_city == "" || response.user.other_data == nil{
                        let vc = self.storyboard?.instantiateViewController(identifier: "CompanionSignup2ViewController") as! CompanionSignup2ViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if response.user.other_data?.bio == ""{
                        let vc = self.storyboard?.instantiateViewController(identifier: "CompanionSignup3ViewController") as! CompanionSignup3ViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if response.user.other_data?.id_proof == ""{
                        let vc = self.storyboard?.instantiateViewController(identifier: "UploadDocsViewController") as! UploadDocsViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if response.user.verify == 0{

                        Constants.Toast.MyToast(message: "Your account is not verified."   )

                    }

                    else{
                        
                        let when = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: when)
                        {
                            let vc = self.storyboard?.instantiateViewController(identifier: "CompanionSignup2ViewController") as! CompanionSignup2ViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                    }


            


                case .failure(let error):
                    print(error)
                }
                
            } failure: { (error) in
                print(error)
            }
            
           

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
