//
//  BookingCancelViewController.swift
//  Alto
//
//  Created by Jaypreet on 01/11/21.
//

import UIKit
import IQKeyboardManagerSwift

class BookingCancelViewController: UIViewController {

    @IBOutlet weak var txtDetail: IQTextView!
    @IBOutlet weak var txtReason: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    var Request : M_Request_Data!
    var PickerView : UIPickerView!

    @IBOutlet weak var btnReason: UIButton!
    var jTableView : ActionPickerController? {
        didSet{
            PickerView?.dataSource = jTableView
            PickerView?.delegate = jTableView
            PickerView?.reloadAllComponents()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Admin_Data == nil){
            btnReason.isHidden = true
        }
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func Dane(_ sender: Any) {
        ChangeMeetingStatus(id: Request.id, status: RequestStatus.CancelledByComapnion.get())

        
    }
    @IBAction func Reason(_ sender: UIButton) {
        
        
        jTableView = ActionPickerController.init(array: [Admin_Data.cancel_reasons.map({ ($0.reason)})], title: txtReason.placeholder ?? "Select", picker: PickerView, viewController: self, sender: sender, configureCellBlock: { (arr, index, status) in
                    if arr.count != 0{
                        self.txtReason.text = arr[0]
                    }
        
                })
    }
    
    func ChangeMeetingStatus(id : Int , status : Int)  {
        if txtReason.CheckText(){
            let dict = ["meeting_id" : id,
                        "status" : status,
                        "reason" : txtReason.text!,
                        "message" : txtDetail.text!
                        
            ] as [String : Any]
            
            APIClients.POST_user_meetingStatusChange(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    self.Request.status = status
                    self.dismiss()
                    


                case .failure(let error):
                    print(error)
                }
                
            } failure: { (error) in
                print(error)
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
