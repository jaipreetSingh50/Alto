//
//  AskLoginViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit

class AskLoginViewController: UIViewController {

    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTerm: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTerm.isUserInteractionEnabled = true
        lblTerm.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        lblPrivacy.isUserInteractionEnabled = true
        lblPrivacy.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        if DataManager.CurrentUserRole == UserRole.Senior.get(){
            lblTitle.text = "Senior"
        }
        else{
            lblTitle.text = "Companion"

        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        self.PresentViewController(identifier: "OptionViewController")
    }
    
    @IBAction func Login(_ sender: Any) {
        self.PresentViewController(identifier: "LoginViewController")

    }
    @IBAction func Register(_ sender: Any) {
        
        self.PresentViewController(identifier: "SetLanguageViewController")

        

    }
    
    @IBAction func Google(_ sender: UIButton) {
        GoogleLogin(btn: sender)
    }
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        guard let text = lblTerm.attributedText?.string else {
            return
        }
        guard let text1 = lblPrivacy.attributedText?.string else {
            return
        }
        if let range = text.range(of: NSLocalizedString("Terms", comment: "Terms")),
           gesture.didTapAttributedTextInLabel(label: lblTerm, inRange: NSRange(range, in: text)) {
            UIApplication.shared.open(URL.init(string:"http://3.134.251.176/terms")!)
            
          
            
        } else if let range = text1.range(of: NSLocalizedString("Privacy Policy", comment: "Privacy Policy")),
                  gesture.didTapAttributedTextInLabel(label: lblPrivacy, inRange: NSRange(range, in: text)) {
            UIApplication.shared.open(URL.init(string:"http://3.134.251.176/policy")!)
  
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
