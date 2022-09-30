//
//  SeniorConfirmationViewController.swift
//  Alto
//
//  Created by Jaypreet on 29/10/21.
//

import UIKit

class SeniorConfirmationViewController: UIViewController {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgBooking: UILabel!
    @IBOutlet weak var imgSec: UIImageView!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    var Request : M_Request_Data!
    var Companion : M_User!

    override func viewDidLoad() {
        super.viewDidLoad()
        imgBooking.text = "Booking #\(Request.id)"
        
        lblAddress.text = "\(Request.address_data?.complete_address ?? ""), \(Request.address_data?.address ?? "")\n\(Request.address_data?.city ?? ""), \(Request.address_data?.state ?? "")\n\(Request.address_data?.country ?? ""), \(Request.address_data?.zip_code ?? "")"

        
       
        let DatesArray = CommonFunctions().convertJSONToArray(arrayObject: Request.request_date) as! [[String : String]]
         if DatesArray.count != 0{
             let arr = DatesArray[0]
            lblDateTime.text = "\(arr["date"]!.getTimeFromTime(currentFormat: DateFormat.dd_MM_yyyy.get(), requiredFormat: DateFormat.dd_MMM_yyyy.get())) \(arr["start_time"]!)"
         }
        lblMessage.text = "Your meeting with \(Companion.full_name ?? "Companion") is in waiting."
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Done(_ sender: Any) {
        self.PresentViewController(identifier: "TabCompanionViewController")
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
