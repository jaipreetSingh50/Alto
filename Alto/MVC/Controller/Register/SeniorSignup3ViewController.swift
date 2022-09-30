//
//  SeniorSignup3ViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit
import CoreLocation
import LocationPicker

class SeniorSignup3ViewController: UIViewController {

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewCountry: UIStackView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewCompleteAddress: UIView!
    @IBOutlet weak var txtCompleteAddress: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    var UserData : M_CurrentUserData!
    var Country_List = [M_Country_data]()
    var State_List = [M_State_data]()
    var City_List = [M_City_data]()
    let locationManager = CLLocationManager()

    var PickerView : UIPickerView!
    var isNewAddress : Bool = false
    var jTableView : ActionPickerController? {
        didSet{
            PickerView?.dataSource = jTableView
            PickerView?.delegate = jTableView
            PickerView?.reloadAllComponents()
        }
    }
    let locationPicker = LocationPickerViewController()
    var Selected_Lat : String = ""
    var Selected_Lng : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        txtCountry.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))
//        txtState.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))
//        txtCity.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))

//        self.GetCountry { (list) in
//            self.Country_List = list.data
//        }
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
        self.viewAddress.isHidden = true
        btnSearch.isHidden = true


        // Do any additional setup after loading the view.
    }
    
    @IBAction func Country(_ sender: UIButton) {
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
        
        
        
//        jTableView = ActionPickerController.init(array: [self.Country_List.map({ ($0.name)})], title: txtCountry.placeholder ?? "Select", picker: PickerView, viewController: self, sender: sender, configureCellBlock: { (arr, index, status) in
//            if arr.count != 0{
//                self.txtCountry.text = arr[0]
//                self.GetState(country_id: self.Country_List[index ?? 0].id) { (list) in
//                    self.State_List = list.data
//                }
//            }
//
//        })
    }
    @IBAction func Address(_ sender: Any) {
        self.SearchLocation(PostLat: Current_lat, PostLng: Current_lat, locationPicker: locationPicker) { (search ,address, lat, lng) in
            self.txtAddress.text = address
            self.Selected_Lat = lat
            self.Selected_Lng = lng
            self.txtCompleteAddress.text = search
            self.viewCompleteAddress.isHidden = false
            self.viewCity.isHidden = false
            self.viewState.isHidden = false
            self.viewCountry.isHidden = false
            self.viewAddress.isHidden = false
            self.btnSearch.isHidden = false

            
            self.getAddressFromLatLon(pdblLatitude: lat, withLongitude: lng) { (address, city, state, country, zip) in
                self.txtAddress.text = address
                self.txtCity.text = city
                self.txtState.text = state
                self.txtCountry.text = country
                self.txtZip.text = zip
                
            }
        }
    }
    @IBAction func City(_ sender: UIButton) {
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
    
    @IBAction func State(_ sender: UIButton) {
        if State_List.count == 0{
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = self.State_List.map({ ($0.name)})
        vc.ViewType = 2
        vc.ViewTitle = txtState.placeholder ?? "Select"
        vc.delegate = self
        vc.isSingleSelection = true
        present(vc, animated: false)

    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Continue(_ sender: Any) {
        if txtAddress.CheckText() && txtState.CheckText()  && txtCountry.CheckText()  {
            
            
            
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


                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        if self.isNewAddress{
                            
                            Constants.CurrentUserData = response.user
                            DataManager.CurrentUserData = response.user
                            self.Dismiss(true)
                        }
                        else{
                            let vc = self.storyboard?.instantiateViewController(identifier: "SeniorAddImageViewController") as! SeniorAddImageViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                    }


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
extension SeniorSignup3ViewController : selectedItemsPopupDelegate{
    func SelectedPopUp(arr: [String] , type: Int) {
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
extension SeniorSignup3ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Current_lat = "\(locValue.latitude)"
        Current_lng = "\(locValue.longitude)"
        locationManager.stopUpdatingLocation()

    }
}
