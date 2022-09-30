//
//  OptionViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit

class OptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Senior(_ sender: Any) {
        Constants.UserRole = UserRole.Senior.get()
        DataManager.CurrentUserRole = Constants.UserRole
        self.PresentViewController(identifier: "AskLoginViewController")
        
        
    }
    
    @IBAction func Companion(_ sender: Any) {
        Constants.UserRole = UserRole.Companion.get()
        DataManager.CurrentUserRole = Constants.UserRole
        self.PresentViewController(identifier: "AskLoginViewController")

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
