//
//  VerificationViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit

class VerificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Done(_ sender: Any) {
        self.PresentViewController(identifier: "LoginViewController")

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
