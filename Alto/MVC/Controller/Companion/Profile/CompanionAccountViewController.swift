//
//  CompanionAccountViewController.swift
//  Alto
//
//  Created by Jaypreet on 29/10/21.
//

import UIKit

class CompanionAccountViewController: UIViewController {

    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var imgUserTitle: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(UploadProfile), name: Notification.Name.NotificationUpdateProfile, object: [:])
        UploadProfile()
        // Do any additional setup after loading the view.
    }
    @objc func UploadProfile()  {
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        imgUserTitle.getImage(url: Constants.CurrentUserData.image ?? "")
        lblTitleName.text = Constants.CurrentUserData.full_name
        
        lblUserName.text = Constants.CurrentUserData.full_name
        lblEmail.text = (Constants.CurrentUserData.email != nil) ? "" : Constants.CurrentUserData.user_name
    }
    
    @IBAction func ChangePassword(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @IBAction func Address(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "MeetingSettingsViewController") as! MeetingSettingsViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @IBAction func Camera(_ sender: Any) {
    }
    @IBAction func AccountSetting(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanionSettingViewController") as! CompanionSettingViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @IBAction func Earning(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "EarningViewController") as! EarningViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @IBAction func NotificationSetting(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "NotificationViewController") as! NotificationViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @IBAction func UpdatePayment(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddCardViewController") as! AddCardViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    
    @IBAction func Help(_ sender: Any) {
    }
    @IBAction func Language(_ sender: Any) {
    }
    @IBAction func LOGOUT(_ sender: Any) {
        Utill.showDialog(message: "Do you want to logout?", parent: self) { (status) in
            if status == 1{
                DataManager.CurrentUserData = nil
                self.PushToOptionViewController()
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
