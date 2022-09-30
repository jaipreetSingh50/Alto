//
//  PaymentViewController.swift
//  Alto
//
//  Created by Jaypreet on 29/10/21.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var imgUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Back(_ sender: Any) {
        Dismiss()
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
