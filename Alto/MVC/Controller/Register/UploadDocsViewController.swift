//
//  UploadDocsViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit
import MobileCoreServices



class UploadDocsViewController: UIViewController {

    @IBOutlet weak var lblDoc: UILabel!
    @IBOutlet weak var imgLicense: UIImageView!
    @IBOutlet weak var imgProof: UIImageView!
    var imagePricker : ImageController!
    var documentPricker : DocumentController!
    var Document : Data!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    

    @IBAction func Proof(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Both.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgProof.image = img
        })
    }
    @IBAction func License(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Both.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgLicense.image = img
        })
    }
    @IBAction func UploadDoc(_ sender: UIButton) {
        
        documentPricker =  DocumentController.init(viewController: self , type : PickerType.Both.Get(), sender: sender, configureCellBlock: { ( url , data) in
            self.Document = data
            self.lblDoc.text = "\(url ?? "")"
            self.lblDoc.numberOfLines = 2
        })
    }
    @IBAction func Done(_ sender: Any) {
        var document : [Data] = []
        if Document != nil{
            document.append(Document)
        }
        
        if Document == nil && imgLicense.image == #imageLiteral(resourceName: "Group 19") &&  imgProof.image == #imageLiteral(resourceName: "Group 19"){
            Constants.Toast.MyToast(message:  "Please upload all required details."  )

            return
        }
        APIClients.POST_user_updateCompanion3(parems: ["":""] , imageKey: ["id_proof" , "license"] , image: [imgProof.image!, imgLicense.image!], OtherData: document , OtherDataKey: ["criminal_record"],storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )

                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    let vc = self.storyboard?.instantiateViewController(identifier: "VerificationViewController") as! VerificationViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
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
