//
//  SeniorProfileViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class SeniorProfileViewController: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgUserPer: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(UploadProfile), name: Notification.Name.NotificationUpdateProfile, object: [:])
        UploadProfile()
        // Do any additional setup after loading the view.
    }
    @objc func UploadProfile()  {
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        imgUserPer.getImage(url: Constants.CurrentUserData.image ?? "")
        lblName.text = Constants.CurrentUserData.full_name
        lblEmail.text = (Constants.CurrentUserData.email != nil) ? "" : Constants.CurrentUserData.user_name
    }
    @IBAction func Addresses(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SeniorDetailViewController") as! SeniorDetailViewController
       
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @IBAction func Camera(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SeniorImageViewController") as! SeniorImageViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
        
    }
    
    @IBAction func ChangePassword(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @IBAction func Account(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SeniorSettingViewController") as! SeniorSettingViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true
        present(navi, animated: true, completion: nil)
    }
    @IBAction func Paymeny(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SeniorPaymentViewController") as! SeniorPaymentViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @IBAction func Review(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SeniorReviewViewController") as! SeniorReviewViewController
        vc.ViewType = 0
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    
    @IBAction func Help(_ sender: Any) {
        self.OpenEmail(subject: "\(Constants.CurrentUserData.user_name ?? "") needs help", Message: "Hi \(Constants.CurrentUserData.user_name ?? ""),\nHow can we hepl you?")
    }
    @IBAction func Language(_ sender: Any) {
    }
    @IBAction func Logout(_ sender: Any) {
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
