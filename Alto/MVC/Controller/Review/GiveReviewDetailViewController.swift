//
//  GiveReviewDetailViewController.swift
//  Alto
//
//  Created by Jaypreet on 09/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import Cosmos

class GiveReviewDetailViewController: UIViewController {
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var txtReview: IQTextView!
    var Request : M_Request_Data!
    var Rate : Double = 0.0
    var Enjoy : String = ""
    var isReSchedule : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Submit(_ sender: Any) {
        ApiReview()
        
    }
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func ApiReview()  {
        var User_id = 0
        if DataManager.CurrentUserRole == UserRole.Senior.get(){
            User_id = Request.companion_id
        }
        else{
            User_id = Request.user_id

        }
        let dict = ["request_id" : Request.id,
                    "rate" : Rate,
                    "enjoy" : Enjoy,
                    "detail" : txtReview.text!,
                    "reschedule" : isReSchedule,
                    "to_id" : User_id
                    
                    
        ] as [String : Any]
        
        APIClients.POST_user_addReview(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message   )

                let when = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    if DataManager.CurrentUserRole == UserRole.Senior.get(){
                        self.PresentViewController(identifier: "TabSeniorViewController")

                    }
                    else{
                        self.PresentViewController(identifier: "TabCompanionViewController")
                        }

                }

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
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
