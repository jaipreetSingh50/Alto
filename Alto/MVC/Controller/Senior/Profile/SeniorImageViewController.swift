//
//  SeniorImageViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class SeniorImageViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    var imagePricker : ImageController!

    override func viewDidLoad() {
        super.viewDidLoad()
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        imgProfile.getImage(url: Constants.CurrentUserData.image ?? "")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss()

    }
    
    @IBAction func Gallery(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Gallery.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgUser.image = img
            self.imgProfile.image = img

        })
    }
    @IBAction func Camera(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Camera.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgUser.image = img
            self.imgProfile.image = img

        })
    }
    @IBAction func Upload(_ sender: Any) {
        apiUploadProfile()
    }
    func apiUploadProfile()  {
        let dict = [
            "device_token" : DataManager.device_token,
            "device_type" : "ios",
            "current_lng" : Current_lng,
            "current_lat" : Current_lat
            
            
        ] as! [String : String]
        
        APIClients.POST_user_update_profile(parems: dict , imageKey: ["image"] , image: [imgUser.image!],storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )
                NotificationCenter.default.post(name: Notification.Name.NotificationUpdateProfile, object: [:])

                Constants.CurrentUserData = response.user
                DataManager.CurrentUserData = response.user
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    
                    self.dismiss()
                }
            case .failure(let error):
                print(error)

           
            }
            
        } failure: { (error) in
            
        } progressUpload: { (per) in
            print(per)
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
