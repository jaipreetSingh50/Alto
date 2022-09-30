//
//  BaseController.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import Foundation
import UIKit
import CoreLocation
import AuthenticationServices
import GoogleSignIn
import LocationPicker
import MapKit
import MessageUI



var Current_lat  : String = ""
var Current_lng  : String = ""

var Admin_Data : M_Admin_Data!

extension UIViewController  : ASAuthorizationControllerDelegate , MFMailComposeViewControllerDelegate{

    func isAppDevelopment() -> Bool {
        #if DEBUG
            return true
        #else
           return false
        #endif
    }

    func GetMeetingTypeString(type : Int) -> String {
        if type == AppMeetingType.Online.value(){
            return AppMeetingType.Online.get()
        }
        else{
            return AppMeetingType.FaceToFace.get()

        }
        
    }
    func GetTotalNumberOfHrs(days : String , start : String , end : String) -> Int {
            let StartTime = (days + " " + start)
            let EndTime = (days + " " + end)
            
            let timeOneDay = EndTime.getTimeInterval(from: StartTime, format: "dd/MM/yyyy HH:mm")
            return timeOneDay 
        
    }
    
    func SearchLocation(PostLat : String , PostLng : String ,locationPicker : LocationPickerViewController ,completion: ((String, String , String,String) -> ())?){
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(PostLat ) ?? 0.0, longitude: Double(PostLng ) ?? 0.0), addressDictionary: nil)
        
        let location = Location(SearchAddress: "", name: "", location: nil, placemark: placemark)
        locationPicker.location = location

        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true

        // default: navigation bar's `barTintColor` or `UIColor.white`
        locationPicker.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        locationPicker.currentLocationButtonBackground = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        
        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true

        locationPicker.mapType = .standard // default: .Hybrid

        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false

        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"

        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"

        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600

        locationPicker.completion = { location in
            // do some awesome stuff with location
            completion!(location?.SearchAddress ?? "" ,location?.address ?? "" , "\(location?.coordinate.latitude ?? 0.0)" , "\(location?.coordinate.longitude ?? 0.0)")
        }
        let navi = UINavigationController.init(rootViewController: locationPicker)
        if #available(iOS 14.0, *) {
            navi.navigationItem.backButtonDisplayMode = .default
        } else {
            
            // Fallback on earlier versions
        }
        navi.navigationItem.hidesBackButton = false
        navi.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navi.navigationBar.isHidden = false
        
        
        present(navi, animated: true, completion: nil)

    }

    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, completion: ((String , String,String, String,String) -> ())?)  {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    if placemarks == nil{
                        return
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                     
                        var addressString : String = ""
                        var country : String = ""
                        var zipCode : String = ""
                        var city : String = ""
                        var state : String = ""
                        
                        
                        if pm.name != nil {
                            addressString =   pm.name! + ", "

                        }
                        
                        if pm.thoroughfare != nil {
                            addressString +=   pm.thoroughfare!

                        }
                        if pm.locality != nil {
                            city = pm.locality!
                        }
                        if pm.administrativeArea != nil {
                            state = pm.administrativeArea!
                        }
                      
                        if pm.country != nil {
                            country = pm.country!
                        }
                        if pm.postalCode != nil {
                            zipCode = pm.postalCode!
                        }
                        completion!(addressString , city , state,country,zipCode)
                        print(addressString)
                  }
            })

        }
    
    func Dismiss(_ animation : Bool = true , _ complition : (()->Void)? = nil)  {
        self.dismiss(animated: animation, completion: complition)
    }
    func PushToOptionViewController()  {
        let vc = storyboard?.instantiateViewController(identifier: "OptionViewController") as! OptionViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    func PushToSetLanguageViewController()  {
        let vc = storyboard?.instantiateViewController(identifier: "OptionViewController") as! OptionViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    func PresentViewController(identifier : String)  {
        let vc = storyboard?.instantiateViewController(identifier: identifier)
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: false, completion: nil)
    }
//    func buildFDLLink(RequestID : String , text : String , type : Int) {
//
//
//        var Link : String = ""
//        switch type {
//        case 1:
//            Link = "feed=\(RequestID)"
//            break
//        case 2:
//            Link = "inviteBy=\(RequestID)"
//            break
//        case 3:
//            Link = "travel=\(RequestID)"
//            break
//        default:
//            break
//        }
//
//
//
//        guard let link = URL(string: "https://letsDetour.com?\(Link )") else { return }
//        let dynamicLinksDomainURIPrefix = "https://letsdetour.page.link/XktS"
//        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
//        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.orem.Letsdetour")
//        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.orem.Letsdetour")
//
//        guard let longDynamicLink = linkBuilder?.url else { return }
//        print("The long URL is: \(longDynamicLink)")
////        ShareURL = "\(longDynamicLink)"
//        ShareText(text: text, link: longDynamicLink)
//
//   }
    
    func ShareText(text : String , link : URL)  {
               
             
            let objectsToShare = [text , link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }

            self.present(activityVC, animated: true, completion: nil)
        
    }
    func CallOnPhone(number : String)  {
        guard let number = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(number)
    }
    func OpenUrl(url : String)  {
        guard let number = URL(string:  url) else { return }
        UIApplication.shared.open(number)
    }
    func OpenEmail(subject : String , Message : String)  {
        let mailVC = MFMailComposeViewController()
        
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["info@alto.com"])
        mailVC.setSubject(subject)
        mailVC.setMessageBody(Message, isHTML: false)

        present(mailVC, animated: true, completion: nil)
    }
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

    }




    func ShowDirection(lat : String , lng : String)  {
        let alert = UIAlertController.init(title: "Select Map", message: "", preferredStyle: .alert)
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps-x-callback://")!){
            let google = UIAlertAction.init(title: "Google Map", style: .default) { (action) in
                print("comgooglemaps://?saddr=&daddr=\(lat),\(lng)&directionsmode=driving")
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps-x-callback://")!)) {
                  UIApplication.shared.open(URL(string:
                    "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(lng)&directionsmode=driving")!)
                } else {
                  print("Can't use comgooglemaps://");
                }
               
            }
            alert.addAction(google)
        }
        let apple = UIAlertAction.init(title: "Apple Map", style: .default) { (action) in
            
            UIApplication.shared.open(URL(string:
                "http://maps.apple.com/?q=\(lat),\(lng)")!)
        }
        alert.addAction(apple)
        
        let Cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(Cancel)
        present(alert, animated: true, completion: nil)

        
    }
    
    func UpdateProfile() {
        let dict = [
            "device_token" : DataManager.device_token,
            "device_type" : "ios",
            "current_lng" : Current_lng,
            "current_lat" : Current_lat,
            "voip_device_token" : DataManager.Push_device_token,
        ] as! [String : String]
        
        APIClients.uploadLocation(parems: dict   , loader : false  , alert : false ,storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                DataManager.CurrentUserData = response.user
                Constants.CurrentUserData = response.user
                NotificationCenter.default.post(name: Notification.Name.NotificationUpdateProfile, object: [:])
                
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        } progressUpload: { (per) in
            print(per)
        }

    }
    
    func GetVideoCall( completion: ((String , String) -> ())?)  {
        let dict = [
            "device_token" : DataManager.device_token,
            "device_type" : "ios",
            "current_lng" : Current_lng,
            "current_lat" : Current_lat,
            "voip_device_token" : DataManager.Push_device_token,
        ] as! [String : String]
        
        APIClients.POST_user_opentok_session(parems: dict   , loader : true  , alert : false ,storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                
                completion!(response.sessiontoken , response.opentok_token)
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        } progressUpload: { (per) in
            print(per)
        }

    }

    
    func GetCountry( _ complition : ((M_Country)->Void)? = nil)  {
        
        APIClients.POST_country_list(parems: ["":""], storyBoard: storyboard!, navigation: self ) { (result) in
            switch result {
            case .success(let response):
                print(response)

                complition!(response)
               


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }


        
    }
    func GetState(country_id : Int , _ complition : ((M_Sate)->Void)? = nil)  {
        
        APIClients.POST_state_list(parems: ["country_id":country_id], storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                complition!(response)
               


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }


        
    }
    func GetCity(state_id : Int , _ complition : ((M_City)->Void)? = nil)  {
        
        APIClients.POST_city_list(parems: ["state_id":state_id], storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                complition!(response)
               


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }


        
    }
    func GetCAtegory( _ complition : ((M_Categories)->Void)? = nil)  {
        
        APIClients.POST_categories(parems: ["":""], storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                complition!(response)
               


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }


        
    }
    func GetLocationFromPicker(vc : UIViewController, _ complition : ((String , String , String , String)->Void)? = nil)  {
        
    }
    func GetAdminDATA( _ complition : ((M_Admin)->Void)? = nil)  {
        
        APIClients.POST_user_adminDetails(parems: ["":""], storyBoard: storyboard!, navigation: self ) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Admin_Data = response.data
                complition!(response)
               


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }


        
    }
    
//    func GooglePlaceImages(id : String, _ complition : ((GMSPlace)->Void)? = nil)   {
        
//
//        let placesClient = GMSPlacesClient()
//
//        // Specify the place data types to return (in this case, just photos).
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))
//
//        placesClient.fetchPlace(fromPlaceID: id,
//                                 placeFields: fields,
//                                 sessionToken: nil, callback: {
//          (place: GMSPlace?, error: Error?) in
//          if let error = error {
//            print("An error occurred: \(error.localizedDescription)")
//            return
//          }
//            complition!(place!)
//
//        })
        
//    }
    func GooglePlaceImage(id : String, img : UIImageView)  {
        

//        let placesClient = GMSPlacesClient()
//
//        // Specify the place data types to return (in this case, just photos).
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))
//
//        placesClient.fetchPlace(fromPlaceID: id,
//                                 placeFields: fields,
//                                 sessionToken: nil, callback: {
//          (place: GMSPlace?, error: Error?) in
//          if let error = error {
//            print("An error occurred: \(error.localizedDescription)")
//            return
//          }
//          if let place = place {
//            // Get the metadata for the first photo in the place photo metadata list.
//            let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
//
//            // Call loadPlacePhoto to display the bitmap and attribution.
//            placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
//              if let error = error {
//                // TODO: Handle the error.
//                print("Error loading photo metadata: \(error.localizedDescription)")
//                return
//              } else {
//                // Display the first image and its attributions.
//                img.image = photo;
//              }
//            })
//          }
//        })
        
    }
    func setUpSignInAppleButton(btn : UIView) {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.mask = .none
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.layer.cornerRadius = 27
        authorizationButton.frame = btn.frame
        authorizationButton.layer.masksToBounds = true
        btn.backgroundColor = .clear
        btn.addSubview(authorizationButton)
    }
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email ]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self

        authorizationController.performRequests()
    }
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
//        AppleLogin(source: appleIDCredential)
            var name: String = appleIDCredential.email ?? ""
            if let nameProvided = appleIDCredential.fullName {
                let firstName = nameProvided.givenName ?? ""
                let lastName = nameProvided.familyName ?? ""
                name = "\(firstName) \(lastName)"
            } else {
                name = ""
            }
            if name == " "{
                name = ""
            }
            self.SocalSignUp(social_id: userIdentifier, Name: name, email: email ?? "", login_type: "1", Image: "")
        
        }
    }
    
    
    func GoogleLogin(btn : UIButton)  {
        let signInConfig = GIDConfiguration.init(clientID: Config.googleClientID)

        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            self.SocalSignUp(social_id: "\(user?.userID ?? "")", Name: user?.profile?.name ?? "", email: user?.profile?.email ?? "", login_type: "1", Image: user?.profile?.imageURL(withDimension: 120)?.absoluteString ?? "" )

            // If sign in succeeded, display the app's main content View.
          }
    }
    func FaceBookLogin( ) {

//        let loginManager = LoginManager()
//
//            if let _ = AccessToken.current {
//                // Access token available -- user already logged in
//                // Perform log out
//
//                // 2
//                loginManager.logOut()
//
//            } else {
//                // Access token not available -- user already logged out
//                // Perform log in
//
//                // 3
//                loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
//
//                    // 4
//                    // Check for error
//                    guard error == nil else {
//                        // Error occurred
//                        print(error!.localizedDescription)
//                        return
//                    }
//
//                    // 5
//                    // Check for cancel
//                    guard let result = result, !result.isCancelled else {
//                        print("User cancelled login")
//                        return
//                    }
//
//
//                    Profile.loadCurrentProfile { (profile, error) in
//
//
//                        if profile?.email == nil {
//                            self?.SocalSignUp(social_id: "\(profile?.userID ?? "")", Name: profile?.name ?? "", email: "\(profile?.userID ?? "")".appending("@facebook.com"), login_type: "1", Image: profile?.imageURL?.absoluteString ?? "" )
//
//                        }
//                        else{
//                            self?.SocalSignUp(social_id: "\(profile?.userID ?? "")", Name: profile?.name ?? "", email: profile?.email ?? "", login_type: "1", Image: profile?.imageURL?.absoluteString ?? "" )
//                        }
//                    }
//                }
//            }
    }

    func SocalSignUp( social_id : String , Name : String , email: String , login_type : String , Image : String ) {
        let dict1 = ["social_id" :social_id,
                    "social_type" : login_type,
                    "email" : email,
                    "country_code" : "",
                    "device_type" : "ios",
                    "device_token" : "",
                     "user_type" :  DataManager.CurrentUserRole as Any ,
                     "full_name" : Name

                    ]
        APIClients.Social_Login(parems: dict1, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )
                DataManager.Auth_Token = response.token

                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
           
                    if DataManager.CurrentUserRole == UserRole.Senior.get(){
                   
                        if response.user.address?.count == 0  {
                            let vc = self.storyboard?.instantiateViewController(identifier: "SeniorSignup3ViewController") as! SeniorSignup3ViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                  
                        
                       else{
                            Constants.CurrentUserData = response.user
                            DataManager.CurrentUserData = response.user
                            self.PresentViewController(identifier: "TabSeniorViewController")
                       }

                    }
                    else{
                   
                        if response.user.other_data?.preferred_city == "" || response.user.other_data == nil{
                            let vc = self.storyboard?.instantiateViewController(identifier: "CompanionSignup2ViewController") as! CompanionSignup2ViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        else if response.user.other_data?.bio == ""{
                            let vc = self.storyboard?.instantiateViewController(identifier: "CompanionSignup3ViewController") as! CompanionSignup3ViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        else if response.user.other_data?.id_proof == ""{
                            let vc = self.storyboard?.instantiateViewController(identifier: "UploadDocsViewController") as! UploadDocsViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        else if response.user.verify == 0{

                            Constants.Toast.MyToast(message: "Your account is not verified."   )

                        }

                        else{
                            
                            Constants.CurrentUserData = response.user
                            DataManager.CurrentUserData = response.user

                            self.PresentViewController(identifier: "TabCompanionViewController")
                        }
                        
                    }
                    
                    
                    
                    
                }
             
                
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }

    }
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@alto.cool"])
            mail.setMessageBody("", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

   
}
