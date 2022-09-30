//
//  SeniorAddImageViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit

class SeniorAddImageViewController: UIViewController {

    @IBOutlet weak var imgUser: UIImageView!
    var imagePricker : ImageController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgUser.image = #imageLiteral(resourceName: "deafult_user")
        // Do any additional setup after loading the view.
    }
    

    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Camara(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Camera.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgUser.image = img
        })
    }
    @IBAction func Gallert(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Gallery.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgUser.image = img
        })
    }
    @IBAction func Register(_ sender: Any) {
        
        if imgUser.image == #imageLiteral(resourceName: "deafult_user"){
            Constants.Toast.MyToast(message: "Please select your profile image."  )
            return
        }
        
        
        APIClients.POST_user_update_profile(parems: ["":""] , imageKey: ["image"] , image: [imgUser.image!],storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )

                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.PresentViewController(identifier: "LoginViewController")

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
