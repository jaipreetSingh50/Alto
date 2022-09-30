//
//  TrackCompanionViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}


class TrackCompanionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imgUser: UIImageView!
    let locationManager = CLLocationManager()
    var isLocationUpdate : Int = 0
    var isMapUpdate : Int = 0

    var markerMeeting : MKMarkerAnnotationView!
    var CompanionMeeting : MKMarkerAnnotationView!
    var Request : M_Request_Data!
    var profileCom : M_User!
    var timerCom : Timer!
    var polyline : MKPolyline!
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
        self.GetComProfile()
        timerCom = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (T) in
            self.GetComProfile()
        })
        SetMarkers() 
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        timerCom.invalidate()
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
        }
        locationManager.stopUpdatingLocation()

    }
    func GetComProfile()  {
        let dict = ["companion_id" : Request.companion_id,
                    ]
        
        APIClients.POST_user_companion_detail(parems: dict , loader : false, alert :false, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                self.profileCom = response.data
                let DatesArray = CommonFunctions().convertJSONToArray(arrayObject: self.Request.request_date) as! [[String : String]]
                if DatesArray.count != 0{
                    let arr = DatesArray[0]

                    
                    let Companion = Capital(title: self.profileCom.full_name ?? "Companion", coordinate: CLLocationCoordinate2D(latitude: Double(self.profileCom.current_lat ?? "0.0") ?? 0.0, longitude: Double(self.profileCom.current_lng ?? "0.0") ?? 0.0), info: "\(self.profileCom.last_name ?? "") is free to play \(self.Request.task) with you at your place from \(arr["date"]!.getTimeFromTime(currentFormat: DateFormat.dd_MM_yyyy.get(), requiredFormat: DateFormat.dd_MMM_yyyy.get())) \(arr["start_time"]!).")
                    self.mapView.addAnnotation(Companion)
                    
                    
                }

            
                self.showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D(latitude: Double(self.profileCom.current_lat ?? "0.0") ?? 0.0, longitude: Double(self.profileCom.current_lng ?? "0.0") ?? 0.0), destinationCoordinate:  CLLocationCoordinate2D(latitude: Double(self.Request.address_data?.lat ?? "0") ?? 0.0, longitude: Double(self.Request.address_data?.lng ?? "0") ?? 0.0))

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    
    
    func SetMarkers()  {
        
        let DatesArray = CommonFunctions().convertJSONToArray(arrayObject: self.Request.request_date) as! [[String : String]]
        if DatesArray.count != 0{
            let arr = DatesArray[0]

            let time = arr["date"]! + " " + arr["start_time"]!

            let Meeting = Capital(title: "\(Request.address_data?.complete_address ?? ""), \(Request.address_data?.address ?? ""), \(Request.address_data?.city ?? ""), \(Request.address_data?.state ?? ""), \(Request.address_data?.country ?? ""), \(Request.address_data?.zip_code ?? "")", coordinate: CLLocationCoordinate2D(latitude: Double(self.Request.address_data?.lat ?? "0") ?? 0.0, longitude: Double(self.Request.address_data?.lng ?? "0") ?? 0.0), info: time.getTimeLeft(format: "dd/MM/yyyy HH:mm"))
            self.mapView.addAnnotation(Meeting)
            
            
        }
        
        
     
        
        
//            let annotation = MKPointAnnotation()
//            annotation.title = i.user_name
//            annotation.accessibilityLabel = "\(i.id)"
//            annotation.subtitle = "".ShowPrice(price: i.distance) + "Km"
//            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(i.current_lat) ?? 0.0, longitude: Double(i.current_lng) ?? 0.0)
//            mapView.addAnnotation(annotation)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       print("hee")
    }
   
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let sourceAnnotation = MKPointAnnotation()

        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()

        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]
            self.polyline = route.polyline
            if self.mapView.overlays.count != 0{
                self.mapView.removeOverlays(self.mapView.overlays)
            }
            self.mapView.addOverlay((self.polyline ), level: MKOverlayLevel.aboveRoads)
            if self.isMapUpdate == 0{
                self.isMapUpdate = 1

                let rect = route.polyline.boundingMapRect
                rect.insetBy(dx: 0.5, dy: 0.5)
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)

        renderer.lineWidth = 2.0

        return renderer
    }

}
