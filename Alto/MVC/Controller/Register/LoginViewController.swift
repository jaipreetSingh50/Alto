//
//  LoginViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSavePassword: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.textContentType = .password
        txtUserName.textContentType = .username
        
        btnSavePassword.setImage(#imageLiteral(resourceName: "ic_checkbox_normal"), for: .normal)
        btnSavePassword.setImage(#imageLiteral(resourceName: "ic_checkbox_selected"), for: .selected)
        if DataManager.CurrentUserRole == UserRole.Senior.get(){

            if DataManager.SeniorRememberEmail != ""{
                txtUserName.text = DataManager.SeniorRememberEmail
                txtPassword.text = DataManager.SeniorRememberPassword
                btnSavePassword.isSelected = true
            }
        }
        else{
            if DataManager.CompanionRememberEmail != ""{
                txtUserName.text = DataManager.CompanionRememberEmail
                txtPassword.text = DataManager.CompanionRememberPassword
                btnSavePassword.isSelected = true
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func Savepassword(_ sender: Any) {
        btnSavePassword.isSelected = !btnSavePassword.isSelected
    }
    
    @IBAction func Back(_ sender: Any) {
        self.PresentViewController(identifier: "OptionViewController")
    }
    
    @IBAction func Login(_ sender: Any) {
        if txtUserName.CheckText() && txtPassword.CheckText(.Password){
            apiLogin()
        }
       
        
    }
    
    
    
    
    @IBAction func ForgotPassword(_ sender: Any) {
        self.PresentViewController(identifier: "ForgotPasswordViewController")
    }
    
    func apiLogin()  {
        let dict = ["email" : txtUserName.text!,
                    "password" : txtPassword.text!]
        
        APIClients.POST_login(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                DataManager.Auth_Token = response.token
                let when = DispatchTime.now() + 0
                DispatchQueue.main.asyncAfter(deadline: when)
                {
           
                    if DataManager.CurrentUserRole == UserRole.Senior.get(){
                        if self.btnSavePassword.isSelected{
                            DataManager.SeniorRememberEmail = self.txtUserName.text!
                            DataManager.SeniorRememberPassword = self.txtPassword.text!
                        }
                        else{
                            DataManager.SeniorRememberEmail = ""
                            DataManager.SeniorRememberPassword = ""
                        }
                        if response.user.address?.count == 0  {
                            let vc = self.storyboard?.instantiateViewController(identifier: "SeniorSignup3ViewController") as! SeniorSignup3ViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                  
                        
                       else{
                            Constants.CurrentUserData = response.user
                            DataManager.CurrentUserData = response.user
                            self.PresentViewController(identifier: "TabSeniorViewController")
                       }

                    }
                    else{
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
                            
                            Constants.CurrentUserData = response.user
                            DataManager.CurrentUserData = response.user

                            self.PresentViewController(identifier: "TabCompanionViewController")
                        }
                        
                    }
                    
                    
                    
                    
                }


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
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
