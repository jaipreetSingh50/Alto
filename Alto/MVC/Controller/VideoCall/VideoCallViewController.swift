//
//  VideoCallViewController.swift
//  Alto
//
//  Created by Jaypreet on 19/01/22.
//

import UIKit
import OpenTok

import AVFoundation


class VideoCallViewController: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    var player: AVAudioPlayer?

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnEnd: UIButton!
    @IBOutlet weak var imgUser1: UIImageView!
    @IBOutlet weak var lblBooking2: UILabel!
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var btnCut: UIButton!
    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnIncoming: UIButton!
    @IBOutlet weak var viewCalling: UIView!
    
    // Replace with your generated session ID
     var kSessionId = ""
    // Replace with your generated token
     var kToken = ""
    var Ksession: OTSession?
    var Kpublisher: OTPublisher?
    var Ksubscriber: OTSubscriber?
    
    var Request : M_Request_Data!
    var isIncoming : Bool = false
    var Request_id : Int = 0
    var timer : Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isIncoming{
            viewCalling.isHidden = true
            viewVideo.isHidden = false
            playSound(name: "Incoming")
            connectToAnOpenTokSession()

        }
        else{
            if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
                myDelegate.OutGoingCall()
            }
            playSound(name: "OutGoing")
            viewCalling.isHidden = true
            viewVideo.isHidden = false
            connectToAnOpenTokSession()
        }
        myView.isHidden = true

        GetMeetingDetail(id : Request_id )
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if (timer != nil){
            timer.invalidate()
        }
    }
    func connectToAnOpenTokSession() {
        Ksession = OTSession(apiKey: Config.kApiKey, sessionId: kSessionId, delegate: self)
        var error: OTError?
        Ksession?.connect(withToken: kToken, error: &error)
        viewCalling.isHidden = true
        viewVideo.isHidden = false

        lblTime.text = "Please wait, connecting...."
        if error != nil {
            print(error!)
        }
    }
    @IBAction func CutCall(_ sender: Any) {
        var error: OTError?
        Ksession?.disconnect(&error)
        player?.stop()
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            myDelegate.EndIncomingCall()
        }
        dismiss()
    }
    
    @IBAction func IncomingCall(_ sender: Any) {

        connectToAnOpenTokSession()
        player?.stop()

    }
    @IBAction func BookingDetail(_ sender: Any) {
        if DataManager.CurrentUserRole == UserRole.Senior.get(){

            let vc = storyboard?.instantiateViewController(identifier: "CompanionDetailViewController") as! CompanionDetailViewController
            let navi = UINavigationController.init(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            navi.isNavigationBarHidden = true
            vc.Request = Request
            present(navi, animated: true, completion: nil)
        }
        else{
            let vc = storyboard?.instantiateViewController(identifier: "BookingDetailViewController") as! BookingDetailViewController
            vc.Request = Request
            let navi = UINavigationController.init(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            navi.isNavigationBarHidden = true
            present(navi, animated: true, completion: nil)
        }
    }
    
    @IBAction func Camera(_ sender: UIButton) {
        if ((Kpublisher?.publishVideo) != nil){
            Kpublisher?.publishVideo = !Kpublisher!.publishVideo
            if Kpublisher?.publishVideo == false{
                sender.setImage(#imageLiteral(resourceName: "ic_camera_off"), for: .normal)
            }
            else{
                sender.setImage(#imageLiteral(resourceName: "ic_camera_on"), for: .normal)

            }
        }
    }
    @IBAction func Audio(_ sender: UIButton) {
        if ((Kpublisher?.publishAudio) != nil){
            Kpublisher?.publishAudio = !Kpublisher!.publishAudio
            if Kpublisher?.publishAudio == false{
                sender.setImage(#imageLiteral(resourceName: "ic_audio_off"), for: .normal)
            }
            else{
                sender.setImage(#imageLiteral(resourceName: "ic_audio_on"), for: .normal)

            }
        }
        
    }
    func ChangeMeetingStatus(id : Int , status : Int)  {
        let dict = ["meeting_id" : id,
                    "status" : status
                    ]
        
        APIClients.POST_user_meetingStatusChange(parems: dict , loader : false , alert : false, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.Request.status = status
//                self.SetRequestView()
                if RequestStatus.Completed.get() == status{
                    let vc = self.storyboard?.instantiateViewController(identifier: "GiveReviewViewController") as! GiveReviewViewController

                    vc.Request = self.Request
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    func GetMeetingDetail(id : Int )  {
        let dict = ["meeting_id" : id,
                    ]
        
        APIClients.POST_user_meetingDetail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.Request = response.data
                self.SetData()
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    func SetData()  {
        if DataManager.CurrentUserRole == UserRole.Senior.get(){

            lblName.text = Request.companion_data?.first_name
            lblName1.text = Request.companion_data?.first_name

            imgUser.getImage(url: Request.companion_data?.image ?? "")
            imgUser1.getImage(url: Request.companion_data?.image ?? "")
        }
        else{
            lblName.text = Request.senior_data?.first_name
            lblName1.text = Request.senior_data?.first_name

            imgUser.getImage(url: Request.senior_data?.image ?? "")
            imgUser1.getImage(url: Request.senior_data?.image ?? "")

        }
        lblBooking2.text = "Booking ID : #\(Request.id)"
        lblBookingID.text = "Booking ID : #\(Request.id)"
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func playSound(name : String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }
            player.numberOfLoops =  -1

            player.play()
            

        } catch let error {
            print(error.localizedDescription)
        }
    }

}


extension VideoCallViewController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")

        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        guard let publisher = OTPublisher(delegate: self, settings: settings) else {
            return
        }
        publisher.publishAudio = true
        publisher.publishVideo = true
        
        self.Kpublisher = publisher
        player?.stop()


        var error: OTError?
        session.publish(publisher, error: &error)
        guard error == nil else {
            print(error!)
            return
        }

        guard let publisherView = publisher.view else {
            return
        }
        let screenBounds = viewCamera.bounds
        publisherView.frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        viewCamera.addSubview(publisherView)
        guard let publisherView1 = publisher.view else {
            return
        }
        let screenBounds1 = myView.bounds
        publisherView1.frame = CGRect(x: 0, y: 0, width: screenBounds1.width, height: screenBounds1.height)
        myView.addSubview(publisherView1)
    }
   func sessionDidDisconnect(_ session: OTSession) {
    
    
    if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
        myDelegate.EndIncomingCall()
    }
        dismiss()
       print("The client disconnected from the OpenTok session.")
   }

   func session(_ session: OTSession, didFailWithError error: OTError) {
       print("The client failed to connect to the OpenTok session: \(error).")
   }

    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("A stream was streamCreated in the session.")

        Ksubscriber = OTSubscriber(stream: stream, delegate: self)
        Ksubscriber?.subscribeToVideo = true
        Ksubscriber?.subscribeToAudio = true

        guard let subscriber = Ksubscriber else {
            return
        }
        ChangeMeetingStatus(id: Request_id, status: RequestStatus.Started.get())

        var error: OTError?
        session.subscribe(subscriber, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        myView.isHidden = false

        for view in viewCamera.subviews {
            view.removeFromSuperview()
        }
        var timeInt : Int =  0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
            let t = timeInt.secondsToHoursMinutesSeconds()
            print(t.3)
            self.lblTime.text = t.3
            timeInt += 1
        })
        
        guard let subscriberView = subscriber.view else {
            return
        }
        subscriberView.frame = viewCamera.bounds
        viewCamera.insertSubview(subscriberView, at: 0)
    }

   func session(_ session: OTSession, streamDestroyed stream: OTStream) {
    if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
        myDelegate.EndIncomingCall()
    }
        dismiss()
       print("A stream was destroyed in the session.")
   }
}
extension VideoCallViewController: OTPublisherDelegate {
   func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
       print("The publisher failed: \(error)")
   }
}
// MARK: - OTSubscriberDelegate callbacks
extension VideoCallViewController: OTSubscriberDelegate {
   public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
       print("The subscriber did connect to the stream.")
   }

   public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
       print("The subscriber failed to connect to the stream.")
   }
}
