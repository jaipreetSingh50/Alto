//
//  ChangePasswordViewController.swift
//  Alto
//
//  Created by Jaypreet on 15/12/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var lblAuto: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    var btnEye : UIButton!
    var btnEye2 : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        imgUser.getImage(url: Constants.CurrentUserData.image!)
        lblAuto.isHidden = true
        btnEye = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 15))
        btnEye.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        btnEye.setImage(#imageLiteral(resourceName: "ic_eye.png"), for: .normal)
        btnEye.setImage(#imageLiteral(resourceName: "ic_hide_eye.png"), for: .selected)
        txtConfirmPassword.rightView = btnEye
        txtConfirmPassword.rightViewMode = .always
        
        btnEye.addTarget(self, action: #selector(self.Password(_:)), for: .touchDown)
        
        btnEye2 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 15))
        btnEye2.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        btnEye2.setImage(#imageLiteral(resourceName: "ic_eye.png"), for: .normal)
        btnEye2.setImage(#imageLiteral(resourceName: "ic_hide_eye.png"), for: .selected)
        txtPassword.rightView = btnEye2
        txtPassword.rightViewMode = .always
        
        btnEye2.addTarget(self, action: #selector(self.Password2(_:)), for: .touchDown)
      
        // Do any additional setup after loading the view.
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
        dismiss()
    }
    
    @IBAction func Update(_ sender: Any) {
        if txtCurrentPassword.CheckText(.PasswordCreate) && txtPassword.CheckText(.PasswordCreate) && txtConfirmPassword.CheckText(.PasswordCreate) && txtPassword.MatchPassword(txt: txtConfirmPassword){
            ApiChangePassword()
        }
    }
    @IBAction func GeneratePassword(_ sender: Any) {
        let txt = CommonFunctions().randomString(length: 12)
        txtPassword.text = txt
        txtConfirmPassword.text = txt
        self.txtConfirmPassword.isSecureTextEntry = false
        self.btnEye.isSelected = true
        
        self.txtPassword.isSecureTextEntry = false
        self.btnEye2.isSelected = true
        self.lblAuto.isHidden = false
        lblAuto.text = "« please write this password before pushing the button 'Update' »"
    }
    func ApiChangePassword() {
        let dict = ["current_password" : txtCurrentPassword.text!,
                    "new_password" : txtPassword.text!,
                    "confirm_password" : txtConfirmPassword.text!
                    ]
        
        APIClients.POST_Change_password(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message   )
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.dismiss()
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
