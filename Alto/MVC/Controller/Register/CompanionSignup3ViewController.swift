//
//  CompanionSignup3ViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import LocationPicker
class CompanionSignup3ViewController: UIViewController {
    @IBOutlet weak var viewCompleteAddress: UIView!
    
    @IBOutlet weak var txtCompleteAddress: UITextField!
    @IBOutlet weak var viewZipCode: UIView!
    @IBOutlet weak var viewArea: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var txtIBAN: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtSate: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var txtDOB: UIDatePicker!
    @IBOutlet weak var txtSkills: UILabel!
    @IBOutlet weak var txtBio: IQTextView!
    @IBOutlet weak var imgUser: UIImageView!
    var imagePricker : ImageController!
    var gender : Int = 1
    var PickerView : UIPickerView!

    var jTableView : ActionPickerController? {
        didSet{
            PickerView?.dataSource = jTableView
            PickerView?.delegate = jTableView
            PickerView?.reloadAllComponents()
        }
    }
    
    var Country_List = [M_Country_data]()
    var State_List = [M_State_data]()
    var City_List = [M_City_data]()
    var Category_List = [M_Categories_data]()
    let locationPicker = LocationPickerViewController()
    var Selected_Lat : String = ""
    var Selected_Lng : String = ""
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        btnMale.setImage(#imageLiteral(resourceName: "radio_button_on-1"), for: .selected)
        btnMale.setImage(#imageLiteral(resourceName: "radio_button_off-1"), for: .normal)
        btnFemale.setImage(#imageLiteral(resourceName: "radio_button_on-1"), for: .selected)
        btnFemale.setImage(#imageLiteral(resourceName: "radio_button_off-1"), for: .normal)
        btnMale.isSelected = true
        txtCountry.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))
        txtSate.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))
//        txtSkills.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))
        imgUser.image = #imageLiteral(resourceName: "deafult_user")
        txtCity.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))
        self.GetCountry { (list) in
            self.Country_List = list.data
        }
        self.GetCAtegory { (list) in
            self.Category_List = list.categories.online.data
            self.Category_List += list.categories.offline.data
        }
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = -18
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        txtDOB.minimumDate = minDate
        txtDOB.maximumDate = maxDate
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        viewCompleteAddress.isHidden = true
        viewCity.isHidden = true
        viewState.isHidden = true
        viewCountry.isHidden = true
        viewArea.isHidden = true
        viewZipCode.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func SearchLocation(_ sender: Any) {
        self.SearchLocation(PostLat: Current_lat, PostLng: Current_lat, locationPicker: locationPicker) { (search, address, lat, lng) in
            self.txtArea.text = address
            self.Selected_Lat = lat
            self.Selected_Lng = lng
            self.viewCompleteAddress.isHidden = false
            self.txtCompleteAddress.text = search
            self.viewCity.isHidden = false
            self.viewState.isHidden = false
            self.viewCountry.isHidden = false
            self.viewArea.isHidden = false
            self.viewZipCode.isHidden = false
            self.getAddressFromLatLon(pdblLatitude: lat, withLongitude: lng) { (address, city, state, country, zip) in
                self.txtArea.text = address
                self.txtCity.text = city
                self.txtSate.text = state
                self.txtCountry.text = country
                self.txtZipCode.text = zip
            }
        }
    }
    
    @IBAction func Country(_ sender: Any) {
        return
        if Country_List.count == 0{
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = self.Country_List.map({ ($0.name)})
        vc.ViewType = 1
        vc.ViewTitle = txtCountry.placeholder ?? "Select"
        vc.delegate = self
        vc.isSingleSelection = true
        present(vc, animated: false)


    }
    @IBAction func Skill(_ sender: Any) {
        if Category_List.count == 0{
            return
        }        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = self.Category_List.map({ ($0.name)})
        vc.ViewType = -2
        vc.ViewTitle = "Select Skilles"
        vc.delegate = self

        present(vc, animated: false)
        
    }
    
    @IBAction func State(_ sender: Any) {
        return
        if State_List.count == 0{
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = self.State_List.map({ ($0.name)})
        vc.ViewType = 2
        vc.ViewTitle = txtSate.placeholder ?? "Select"
        vc.delegate = self
        vc.isSingleSelection = true
        present(vc, animated: false)
        
    }
    @IBAction func City(_ sender: Any) {
        return
        if City_List.count == 0{
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = self.City_List.map({ ($0.name)})
        vc.ViewType = 3
        vc.ViewTitle = txtCity.placeholder ?? "Select"
        vc.delegate = self
        vc.isSingleSelection = true
        present(vc, animated: false)

    }
    @IBAction func BAck(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Camers(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self , type : PickerType.Both.Get(), sender: sender, configureCellBlock: { (img, url) in
            self.imgUser.image = img
        })
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
    func AddAddress()  {
            
            let dict = ["address" : txtArea.text!,
                        "city" : txtCity.text!,
                        "state" : txtSate.text!,
                        "zip_code" : txtZipCode.text!,
                        "country" : txtCountry.text!,
                        "lat" : Selected_Lat,
                        "lng" : Selected_Lng,
                        "complete_address" : txtCompleteAddress.text!,
                        ]
            
            APIClients.POST_user_updateSeniorAddress(parems: dict , storyBoard: storyboard!, navigation: self) { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    Constants.Toast.MyToast(message: response.message ?? "")
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        let vc = self.storyboard?.instantiateViewController(identifier: "UploadDocsViewController") as! UploadDocsViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
            } failure: { (error) in
                print(error)
            }
    }
    @IBAction func Continue(_ sender: Any) {
        
        if CheckTextField().CheckText(text: txtBio.text!, String_type: "Bio", view: txtBio!)  {
            if txtSkills.text == ""{
                Constants.Toast.MyToast(message: "Please select your Skills."  )
                return
            }
            if txtCountry.text == ""{
                Constants.Toast.MyToast(message: "Please select your location."  )
                return
            }
            if imgUser.image == #imageLiteral(resourceName: "deafult_user"){
                Constants.Toast.MyToast(message: "Please select your profile image."  )
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateDOB = formatter.string(from: txtDOB.date)
                 
            let dict = ["bio" : txtBio.text!,
                         "skills" : txtSkills.text!,
                         "dob" : dateDOB,
                         "country" : txtCountry.text!,
                         "city" : txtCity.text!,
                         "state" : txtSate.text!,
                         "area" : txtArea.text!,
                         "zip_code" : txtZipCode.text!,
                         "IBAN" : "IBan",
                         "gender" : gender

                        ] as [String : Any]
            
            APIClients.POST_user_updateCompanion2(parems: dict , imageKey: ["image"] , image: [imgUser.image!],storyBoard: storyboard!, navigation: self) { (result) in
                switch result {
                case .success(let response):
                    print(response)
//                    Constants.Toast.MyToast(message: response.message ?? ""  )

                    self.AddAddress()
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
extension CompanionSignup3ViewController : selectedItemsPopupDelegate{
    func SelectedPopUp(arr: [String], type: Int) {
        switch type {
        case -2:
            txtSkills.text = arr.joined(separator: ",")
        case 1:
            if txtCountry.text != arr[0]{
                txtSate.text = ""
                txtCity.text = ""
                txtZipCode.text = ""
            }
            txtCountry.text = arr[0]
            let ids = Country_List.filter({ ($0.name == arr[0])})
            if ids.count != 0{
                self.GetState(country_id: ids[0].id) { (list) in
                        self.State_List = list.data
                }
            }
        case 2:
            if txtSate.text != arr[0]{
                txtCity.text = ""
                txtZipCode.text = ""
            }
            txtSate.text = arr[0]
            let ids = State_List.filter({ ($0.name == arr[0])})
            if ids.count != 0{
                self.GetCity(state_id: ids[0].id) { (list) in
                    self.City_List = list.data
                }
            }
        case 3:
            if txtCity.text != arr[0]{
                txtZipCode.text = ""
            }
            txtCity.text = arr[0]
        default:
            break
        }
    }
}
extension CompanionSignup3ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Current_lat = "\(locValue.latitude)"
        Current_lng = "\(locValue.longitude)"
        locationManager.stopUpdatingLocation()
    }
}
