//
//  CompanionSettingViewController.swift
//  Alto
//
//  Created by Jaypreet on 29/10/21.
//

import UIKit
import LocationPicker

class CompanionSettingViewController: UIViewController {
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCompleteAddress: UITextField!
    @IBOutlet weak var DOB: UIDatePicker!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var imgUserInfo: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewDocument: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewInfromation: UIView!
    @IBOutlet weak var underInformation: UILabel!
    @IBOutlet weak var lblInformation: UILabel!
    @IBOutlet weak var underAddressDetails: UILabel!
    @IBOutlet weak var lblAddressDetails: UILabel!
    @IBOutlet weak var underDocumnets: UILabel!
    @IBOutlet weak var lblDocumnets: UILabel!
    @IBOutlet weak var imgIDProof: UIImageView!
    @IBOutlet weak var imgLicence: UIImageView!
    @IBOutlet weak var lblDocName: UILabel!
    var gender : Int = 1
    var imagePricker : ImageController!
    var Country_List = [M_Country_data]()
    var State_List = [M_State_data]()
    var City_List = [M_City_data]()
    var documentPricker : DocumentController!
    let locationPicker = LocationPickerViewController()
    var Selected_Lat : String = ""
    var Selected_Lng : String = ""
    @IBOutlet weak var lblMessage: UILabel!

    var Document : Data!
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView(type : 1)
        let calendar = Calendar(identifier: .gregorian)

         let currentDate = Date()
         var components = DateComponents()
         components.calendar = calendar

         components.year = -18
         components.month = 12
         let maxDate = calendar.date(byAdding: components, to: currentDate)!

         components.year = -150
         let minDate = calendar.date(byAdding: components, to: currentDate)!
        DOB.minimumDate = minDate
        DOB.maximumDate = maxDate
        
        btnMale.setImage(#imageLiteral(resourceName: "radio_button_off-1"), for: .normal)
        btnMale.setImage(#imageLiteral(resourceName: "radio_button_on"), for: .selected)
        btnFemale.setImage(#imageLiteral(resourceName: "radio_button_off-1"), for: .normal)
        btnFemale.setImage(#imageLiteral(resourceName: "radio_button_on"), for: .selected)

        NotificationCenter.default.addObserver(self, selector: #selector(UploadProfile), name: Notification.Name.NotificationUpdateProfile, object: [:])
        SetViewData()

        // Do any additional setup after loading the view.
    }
    @objc func UploadProfile()  {
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        SetViewData()

    }
    
    
    @IBAction func Address(_ sender: Any) {
        self.SearchLocation(PostLat: Selected_Lat, PostLng: Selected_Lng, locationPicker: locationPicker) { (search ,address, lat, lng)  in
            self.txtAddress.text = address
            self.Selected_Lat = lat
            self.Selected_Lng = lng
            self.txtCompleteAddress.text = search

            
            self.getAddressFromLatLon(pdblLatitude: lat, withLongitude: lng) { (address, city, state, country, zip) in
                self.txtAddress.text = address
                self.txtCity.text = city
                self.txtState.text = state
                self.txtCountry.text = country
                self.txtZip.text = zip
                
            }
        }
    }
    func SetViewData() {
        txtFirstName.text  = Constants.CurrentUserData.first_name
        txtLastName.text  = Constants.CurrentUserData.last_name
        txtUsername.text  = Constants.CurrentUserData.user_name
        txtEmail.text  = Constants.CurrentUserData.email
        DOB.date = Constants.CurrentUserData.dob?.GetDateFromString(format: DateFormat.dd_MM_yyyy.get()) ?? Date()
        gender = Constants.CurrentUserData.gender ?? 1
        if gender ==  1{
            btnFemale.isSelected = false
            btnMale.isSelected = true
        }
        else{
            btnFemale.isSelected = true
            btnMale.isSelected = false
        }
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        imgUserInfo.getImage(url: Constants.CurrentUserData.image ?? "")
        
        imgIDProof.getImage(url: Constants.CurrentUserData.other_data?.id_proof ?? "")
        imgLicence.getImage(url: Constants.CurrentUserData.other_data?.license ?? "")
        lblDocName.text = Constants.CurrentUserData.other_data?.criminal_record
        if Constants.CurrentUserData.address?.count == 0{
            return
        }
        let address = Constants.CurrentUserData.address?[0]
        Selected_Lat = address?.lat ?? Current_lat
        Selected_Lng = address?.lng ?? Current_lng
        txtAddress.text = address?.address
        txtCity.text = address?.city
        txtState.text = address?.state
        txtCountry.text = address?.country
        txtZip.text = address?.zip_code
        txtCompleteAddress.text = address?.complete_address
        

    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Gender(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            gender = 2
            btnFemale.isSelected = true
            btnMale.isSelected = false
        default:
            gender = 1
            btnFemale.isSelected = false
            btnMale.isSelected = true
        }
    }
   
    @IBAction func ContinueAddress(_ sender: Any) {
        if Constants.CurrentUserData.address?.count == 0{
            apiUpdateAddress()
        }
        else{
            let address = Constants.CurrentUserData.address?[0]
            
            DeleteAddress(id: address?.id ?? 0)
        }
        
    }
    @IBAction func ContinueDoc(_ sender: Any) {
        apiUploadDoc()
    }
    @IBAction func UploadDoc(_ sender: UIButton) {
        documentPricker =  DocumentController.init(viewController: self , type : PickerType.Both.Get(), sender: sender, configureCellBlock: { ( url , data) in
            self.Document = data
            self.lblDocName.text = "\(url ?? "")"
            self.lblDocName.numberOfLines = 2
        })
    }
    @IBAction func Licence(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Both.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgLicence.image = img

        })
    }
    @IBAction func IDProof(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Both.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgIDProof.image = img

        })
    }
    @IBAction func Document(_ sender: Any) {
        SetView(type : 3)
    }
    @IBAction func ContinueInfo(_ sender: Any) {
        apiUpdateProfile()
    }
    @IBAction func AccountDetail(_ sender: Any) {
        SetView(type : 2)
    }
    @IBAction func Information(_ sender: Any) {
        SetView(type : 1)
    }
    func SetView(type : Int) {
        switch type {
        case 1:
            underInformation.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            underAddressDetails.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underDocumnets.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblInformation.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblAddressDetails.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblDocumnets.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            viewInfromation.isHidden = false
            viewAddress.isHidden = true
            viewDocument.isHidden = true
            
        case 2:
            underInformation.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underAddressDetails.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            underDocumnets.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblInformation.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblAddressDetails.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblDocumnets.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            viewInfromation.isHidden = true
            viewAddress.isHidden = false
            viewDocument.isHidden = true


        case 3:
            underInformation.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underAddressDetails.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underDocumnets.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblInformation.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblAddressDetails.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblDocumnets.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)

            viewInfromation.isHidden = true
            viewAddress.isHidden = true
            viewDocument.isHidden = false


        default:
            break
        }
    }
    @IBAction func Camera(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Both.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgUser.image = img
            self.imgUserInfo.image = img

        })
    }
    func apiUpdateProfile() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateDOB = formatter.string(from: DOB.date)
        let dict = [
            "device_token" : DataManager.device_token!,
            "device_type" : "ios",
            "current_lng" : Current_lng,
            "current_lat" : Current_lat,
            "dob" : dateDOB,
            "user_name" : txtUsername.text!,
            "gender" : gender,
            "first_name" : txtFirstName.text!,
            "last_name" : txtLastName.text!,
//            "phone" : txtPhoneNumber.text!,
//            "country_code" : txtPhoneNumber.selectedCountry?.phoneCode as Any ,
//            "country_code_text" : txtPhoneNumber.selectedCountry?.code.rawValue as Any
            
            
        ] as! [String : Any]
        
        APIClients.POST_user_update_profile(parems: dict , imageKey: ["image"] , image: [imgUser.image!],storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )
                Constants.CurrentUserData = response.user
                DataManager.CurrentUserData = response.user
                NotificationCenter.default.post(name: Notification.Name.NotificationUpdateProfile, object: [:])

           
                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    
                }
            case .failure(let error):
                print(error)

           
            }
            
        } failure: { (error) in
            
        } progressUpload: { (per) in
            print(per)
        }

    }
    func apiUpdateAddress() {
        
        
        
        let dict = ["address" : txtAddress.text!,
                    "city" : txtCity.text!,
                    "state" : txtState.text!,
                    "zip_code" : txtZip.text!,
                    "country" : txtCountry.text!,
                    "lat" : Selected_Lat,
                    "lng" : Selected_Lng,
                    "complete_address" : txtCompleteAddress.text!,

        ]
        
        APIClients.POST_user_updateSeniorAddress(parems: dict , storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""   )
                Constants.CurrentUserData = response.user
                DataManager.CurrentUserData = response.user
                self.SetViewData()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                 
                }


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
        
        
        
        
        
    }
    func DeleteAddress(id : Int )  {
        let ids = Constants.CurrentUserData.address?.map({ ($0.id)})
        let dict = ["address_id" : ids,
                    ]
        
        APIClients.POST_user_userdeleteAddress(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.apiUpdateAddress()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }

    
    func apiUploadDoc() {
        var document : [Data] = []
        if Document != nil{
            document.append(Document)
        }
        APIClients.POST_user_ProfileCompanion3(parems: ["":""] , imageKey: ["id_proof" , "license"] , image: [imgIDProof.image!, imgLicence.image!], OtherData: document , OtherDataKey: ["criminal_record"],storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )

                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    
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
extension CompanionSettingViewController : selectedItemsPopupDelegate{
    func SelectedPopUp(arr: [String], type: Int) {
        switch type {
        case 1:
            if txtCountry.text != arr[0]{
                txtState.text = ""
                txtCity.text = ""
                txtZip.text = ""
            }
            txtCountry.text = arr[0]
            let ids = Country_List.filter({ ($0.name == arr[0])})
            if ids.count != 0{
                self.GetState(country_id: ids[0].id) { (list) in
                        self.State_List = list.data
                }
            }

        case 2:
            if txtState.text != arr[0]{
                txtCity.text = ""
                txtZip.text = ""
            }
            txtState.text = arr[0]
            let ids = State_List.filter({ ($0.name == arr[0])})
            if ids.count != 0{
                self.GetCity(state_id: ids[0].id) { (list) in
                    self.City_List = list.data
                }
            }
           
        case 3:
            if txtCity.text != arr[0]{
                txtZip.text = ""
            }
            txtCity.text = arr[0]
        default:
            break
        }
    }
}
