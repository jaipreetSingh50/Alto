//
//  BookingConfirmationViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class BookingConfirmationViewController: UIViewController {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblContact: UIButton!
    
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblBooking: UILabel!
    @IBOutlet weak var lblConfirmation: UILabel!
    var Request : M_Request_Data!
    var Companion : M_User!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblBooking.text = "Booking #\(Request.id)"
        lblConfirmation.text = "\(Companion.full_name ?? "Companion") has received the same booking number which will help you to identify him"
        
        lblDetail.text = "Your meeting with \(Companion.full_name ?? "Companion") is in waiting."
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
//        if (Admin_Data != nil){
//            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//
//            lblContact.setAttributedTitle(NSAttributedString.init(string: "Call Alto " +  Admin_Data.phone_number, attributes: underlineAttribute), for: .normal)
//        }
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]

        lblContact.setAttributedTitle(NSAttributedString.init(string: "Contact Alto " + "info@alto.cool", attributes: underlineAttribute), for: .normal)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func Done(_ sender: Any) {
        self.PresentViewController(identifier: "TabSeniorViewController")

    }
    @IBAction func Call(_ sender: Any) {
       sendEmail()
        
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
