//
//  SetMeetingTypeViewController.swift
//  Alto
//
//  Created by Jaypreet on 20/01/22.
//

import UIKit

class SetMeetingTypeViewController: UIViewController {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnOnlinr: UIButton!
    @IBOutlet weak var btnFaceToFace: UIButton!
    @IBOutlet weak var lblName: UILabel!
    var MeetingType : Int = AppMeetingType.Online.value()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = Constants.CurrentUserData.full_name
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        btnOnlinr.backgroundColor = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
        btnFaceToFace.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnOnlinr.SetColorImage(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        btnFaceToFace.SetColorImage(color: UIColor.gray)


        // Do any additional setup after loading the view.
    }
    
    @IBAction func OnlineMeeting(_ sender: Any) {
        btnOnlinr.backgroundColor = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
        btnFaceToFace.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        MeetingType = AppMeetingType.Online.value()
        btnOnlinr.SetColorImage(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        btnFaceToFace.SetColorImage(color: UIColor.gray)

    }
    @IBAction func FaceToFace(_ sender: Any) {
        btnOnlinr.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnFaceToFace.backgroundColor = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
        MeetingType = AppMeetingType.FaceToFace.value()
        btnFaceToFace.SetColorImage(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        btnOnlinr.SetColorImage(color: UIColor.gray)
    }
    
    @IBAction func Continue(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddMeetingViewController") as! AddMeetingViewController
        vc.Language = ""
        vc.MeetingType = MeetingType
     
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true
        present(navi, animated: true, completion: nil)
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
