//
//  CompanionOtherDetailViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class CompanionOtherDetailViewController: UIViewController {
    @IBOutlet weak var imgIDProof: UIImageView!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var imgId: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    var profileCom : M_User!
    @IBOutlet weak var viewDoc: UIView!
    @IBOutlet weak var lblContact: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgIDProof.getImage(url: profileCom.other_data?.id_proof ?? "")
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        if profileCom.other_data?.criminal_record == ""{
            viewDoc.isHidden = true
        }
        else{
            lblDocName.text = profileCom.other_data?.criminal_record
        }
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]

        lblContact.setAttributedTitle(NSAttributedString.init(string: "Contact Alto " + "info@alto.cool", attributes: underlineAttribute), for: .normal)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func BAck(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func View(_ sender: Any) {
        
        
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
