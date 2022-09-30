//
//  PeopleNearByViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit
import MapKit
import CoreLocation

class PeopleNearByViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var Tags : String = ""
    var Date : String = ""
    var Schdule : Int = 0
    var startTime : String = ""
    var EndTime : String = ""
    var isLocationUpdate : Int = 0
    var CollectionNearby = [M_drivers_data]()
    var DateArray = [[String : String]]()
    var Language : String = ""
    var MeetingType : Int = 0
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var imgUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.mapView.showsUserLocation = true

        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Current_lat = "\(locValue.latitude)"
        Current_lng = "\(locValue.longitude)"
        mapView.delegate = self
        if isLocationUpdate == 0{
            isLocationUpdate = 1
            
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(Current_lat) ?? 0.0, longitude: Double(Current_lng) ?? 0.0), span: span)
            mapView.setRegion(region, animated: true)
            if DataManager.CurrentUserRole == UserRole.Senior.get(){

                GetNearByPeople()
            }
            else{
                GetNearByPeopleSenior()
            }
        }
        locationManager.stopUpdatingLocation()

    }
    
    func GetNearByPeople()  {
        let dict = ["lat" : Current_lat,
                    "lng" : Current_lng]
        
        APIClients.POST_user_nearbyCompanion(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                self.CollectionNearby = response.drivers
//                self.CollectionNearby.removeFirst()
                self.SetMarkers()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    
    func GetNearByPeopleSenior()  {
        let dict = ["lat" : Current_lat,
                    "lng" : Current_lng]
        
        APIClients.POST_user_nearbySenior(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                self.CollectionNearby = response.drivers
//                self.CollectionNearby.removeFirst()
                self.SetMarkers()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    
    
    func SetMarkers()  {
        var markers = [MKPointAnnotation]()
        for i in self.CollectionNearby{
            for j in i.address{
                if j.lat != ""{
                    let annotation = MKPointAnnotation()
                    
                    annotation.title = i.full_name
                    annotation.accessibilityLabel = "\(i.id)"
                    annotation.subtitle = j.complete_address + ", " + j.address
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(j.lat) ?? 0.0, longitude: Double(j.lng) ?? 0.0)
                    markers.append(annotation)
                }
            }

        }
        mapView.addAnnotations(markers)

    }

   
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var vi : MKAnnotationView!
        for i in self.CollectionNearby{
            for j in i.address{
                if j.lat != ""{
                    if annotation.coordinate.latitude == Double(j.lat) ?? 0.0 && annotation.coordinate.longitude == Double(j.lng) ?? 0.0 {

                        vi = mapView.dequeueReusableAnnotationView(withIdentifier: i.user_name)
                        if vi == nil{
                            vi = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: i.user_name)
                        }
                        vi.annotation = annotation
//                        vi.image = #imageLiteral(resourceName: "map_marker")
                        vi.rightCalloutAccessoryView = selectLocationButton(id: i.id)
                        vi.canShowCallout = true
                    }
                }

            }
        }

        return vi
    }
    public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let pins = mapView.annotations.filter { $0 is MKPinAnnotationView }
        assert(pins.count <= 1, "Only 1 pin annotation should be on map at a time")

        if let userPin = views.first(where: { $0.annotation is MKUserLocation }) {
            userPin.canShowCallout = true
        }
    }

 
    func selectLocationButton(id : Int) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(#imageLiteral(resourceName: "ic_next_grey"), for: .normal)
        button.addTarget(self, action: #selector(self.OpenView(_:)), for: .touchDown)
        button.tag = id
        
        button.setTitleColor(view.tintColor, for: UIControl.State())
        return button
    }
    @IBAction func OpenView(_ sender: UIButton) {
        for i in self.CollectionNearby{
            for j in i.address{
                if j.lat != ""{

                    if sender.tag == i.id{
                        if DataManager.CurrentUserRole == UserRole.Senior.get(){

                            let vc = storyboard?.instantiateViewController(identifier: "CompanionProfileViewController") as! CompanionProfileViewController
                            vc.Tags = Tags
                            vc.Date = Date
                            vc.startTime = startTime
                            vc.EndTime = EndTime
                            vc.Com_Id = i.id
                            vc.DateArray = DateArray
                            vc.Language = Language
                            vc.MeetingType = MeetingType
                            
                            navigationController?.pushViewController(vc, animated: true)
                            break
                           
                        }
                        else{
                            let vc = storyboard?.instantiateViewController(identifier: "ConfrimSeniorMeetingViewController") as! ConfrimSeniorMeetingViewController
                            vc.Tags = Tags
                            vc.Date = Date
                            vc.startTime = startTime
                            vc.EndTime = EndTime
                            vc.Senior_Id = i.id
                            vc.DatesArray = DateArray
                            vc.Address = j
                            vc.Language = Language
                            vc.MeetingType = MeetingType
                            navigationController?.pushViewController(vc, animated: true)
                            break
                            
                        }
                    }
                }

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
