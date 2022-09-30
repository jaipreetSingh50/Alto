//
//  CompanionDetailViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit
import PassKit
import Stripe



class CompanionDetailViewController: UIViewController {
    @IBOutlet weak var btnPay: UIButton!
    
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var lblLanguages: UILabel!
    @IBOutlet weak var lblTasks: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var c_table_h: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblTimeEst: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblBooking: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCom: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    var Request : M_Request_Data!
    var profileCom : M_User!
    var DatesArray = [[String : String]]()
    @IBOutlet weak var btnTrack: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewMeetingTime: UIView!
    var PayableAmount : Double = 0.0
    
    var paymentSheet: PaymentSheet?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetComProfile()

        
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        tableView.RegisterTableCell("ShowTimeTableViewCell")

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(UploadProfile), name: Notification.Name.NotificationUpdateProfile, object: [:])
        lblLanguages.text = Request.meeting_lang
        lblTasks.text = Request.task
        // Do any additional setup after loading the view.
        if Request.paid ?? 0 == 1{
            btnPay.isHidden = true
        }
        else{
            btnPay.isHidden = false

        }
        switch Request.status {
        
        case RequestStatus.Completed.get():
            btnTrack.isHidden = true
            btnReview.isHidden = false
            btnCancel.isHidden = true
            viewMeetingTime.isHidden = true
        case RequestStatus.CancelledByComapnion.get() , RequestStatus.CancelledBySenior.get() , RequestStatus.Rejected.get() :
            btnTrack.isHidden = true
            btnReview.isHidden = true
            btnCancel.isHidden = true
            viewMeetingTime.isHidden = true
            btnPay.isHidden = true

        case RequestStatus.Accepted.get() , RequestStatus.Confirmed.get() , RequestStatus.New.get():
            btnTrack.isHidden = false
            btnReview.isHidden = true
            btnCancel.isHidden = false
        
        default:
            break
        }
        if Request.meeting_type == AppMeetingType.Online.value(){
            viewAddress.isHidden = true
            btnTrack.isHidden = true

        }
        self.GetAdminDATA { (data) in
            print(data)
        }
    }
    @IBAction func Review(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "GiveReviewViewController") as! GiveReviewViewController
        vc.Request = self.Request
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func UploadProfile()  {
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
       
    }
    @IBAction func Payment(_ sender: Any) {
        var totalHrs = 0.0
        DatesArray = CommonFunctions().convertJSONToArray(arrayObject: Request.request_date) as! [[String : String]]

        for i in DatesArray{
            totalHrs += Double(self.GetTotalNumberOfHrs(days: i["date"]!, start: i["start_time"]!, end: i["end_time"]!))
        }
        let amount = totalHrs * Double(Admin_Data.hourly_rate)!
        PayableAmount = amount
        checkoutAction(amount: amount, text: Request.companion_data?.user_name ?? "")
//        MakePayment(amount: amount, text: Request.companion_data?.user_name ?? "")
    }
    func SetRequestView()  {
         DatesArray = CommonFunctions().convertJSONToArray(arrayObject: Request.request_date) as! [[String : String]]
         if DatesArray.count != 0{
             let arr = DatesArray[0]

            lblTime.text = "\(profileCom.last_name ?? "") is ready for \(GetMeetingTypeString(type: Request.meeting_type ?? 2)) meeting"
            let time = arr["date"]! + " " + arr["start_time"]!
            lblTimeEst.text = time.getTimeLeft(format: "dd/MM/yyyy HH:mm")
         }
        
        lblName.text = profileCom.full_name
        lblBooking.text = "BOOKING #\(Request.id)"
        lblBio.text = profileCom.other_data?.bio
   
        
        imgCom.getImage(url: Request.companion_data?.image ?? "")

        lblAddress.text = "\(Request.address_data?.complete_address ?? ""), \(Request.address_data?.address ?? ""),\n\(Request.address_data?.city ?? ""), \(Request.address_data?.state ?? ""), \(Request.address_data?.country ?? ""),\n\(Request.address_data?.zip_code ?? "")"
        c_table_h.constant = CGFloat(DatesArray.count * 40)
        
        
        tableView.reloadData()
        
    }
    func GetComProfile()  {
        let dict = ["companion_id" : Request.companion_id,
                    ]
        
        APIClients.POST_user_companion_detail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                self.profileCom = response.data
                self.SetRequestView()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    func CancelMeeting()  {
        let dict = ["meeting_id" : Request.id,
                    "status" : 2
                    ]
        
        APIClients.POST_user_meetingStatusChange(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                self.dismiss()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func ViewFullProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanionFullDetailViewController") as! CompanionFullDetailViewController
        vc.Com_Id = Request.companion_id
        vc.isRequest = true
        vc.Request = Request
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func Track(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TrackCompanionViewController") as! TrackCompanionViewController
        vc.Request = Request
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func CancelMeeting(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanionCancellationPolicyViewController") as! CompanionCancellationPolicyViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func MakePayment(amount : Double , text : String) {
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        let paymentItem = PKPaymentSummaryItem.init(label: text, amount: NSDecimalNumber(value: amount))

        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.currencyCode = "USD" // 1
            request.countryCode = "US" // 2
            request.merchantIdentifier = "merchant.com.orem.Alto"// 3
            request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
            request.supportedNetworks = paymentNetworks // 5
            request.paymentSummaryItems = [paymentItem] // 6
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                Constants.Toast.MyToast(message: "Your account is not verified."   )

                return
            }
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
        }
    }
    func setUpPayment(stripe : M_Stripe_Data){
        var configuration = PaymentSheet.Configuration()
        configuration.applePay = .init(
          merchantId: "merchant.com.orem.Alto",
          merchantCountryCode: "US"
        )
        
        STPAPIClient.shared.publishableKey = stripe.publishableKey
        // MARK: Create a PaymentSheet instance
        configuration.merchantDisplayName = "Alto"
        configuration.customer = .init(id: stripe.customer, ephemeralKeySecret: stripe.ephemeralKey)
        // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
        // methods that complete payment after a delay, like SEPA Debit and Sofort.
        configuration.allowsDelayedPaymentMethods = true
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: stripe.paymentIntent, configuration: configuration)

        DispatchQueue.main.async {
            self.paymentSheet?.present(from: self) { paymentResult in
              // MARK: Handle the payment result
              switch paymentResult {
              case .completed:
                  self.ApiPaid(token : stripe.paymentIntent)
                print("Your order is confirmed")
              case .canceled:
                print("Canceled!")
              case .failed(let error):
                print("Payment failed: \(error)")
              }
            }
        }
    }
    func checkoutAction(amount : Double , text : String) {
        ApiSetPayment(amount : amount)

    }
        
    

 
}
extension CompanionDetailViewController : CancelMeetingDelegate{
    func CancelMeetingStatus(viewType : Int , id : Int)  {
        CancelMeeting()
    }
}
extension CompanionDetailViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTimeTableViewCell", for: indexPath) as! ShowTimeTableViewCell
        cell.selectionStyle = .none
        let dates = DatesArray[indexPath.row]
        cell.lblDate.text = "\(dates["date"] ?? "")".getTimeFromTime(currentFormat: DateFormat.dd_MM_yyyy.get(), requiredFormat: DateFormat.dd_MMM_yyyy.get())
        
        cell.lblTime.text = "\((dates["date"]! + " " + dates["start_time"]!).getTime(format: "hh:mm a")) to \((dates["date"]! + " " + dates["end_time"]!).getTime(format: "hh:mm a"))"
                            
        return cell
    }
   
}
extension CompanionDetailViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss()
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        ApiPaid(token : "")
    }
    func ApiSetPayment(amount : Double)  {
        let dict = ["cost" : amount,
                    
        ] as [String : Any]
        
        APIClients.POST_stripeKeyInfo(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.btnPay.isHidden = false
                self.setUpPayment(stripe : response.data)


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    func ApiPaid(token : String)  {
        let dict = ["meeting_id" : Request.id,
                    "amount" : PayableAmount,
                    "paid" : 1,
                    "paymentIntent" : token
        ] as [String : Any]
        
        APIClients.POST_user_meetingPaid(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                self.dismiss()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    
}
