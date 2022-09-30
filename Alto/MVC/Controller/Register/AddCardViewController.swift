//
//  AddCardViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit

class AddCardViewController: UIViewController {
    @IBOutlet weak var viewVerified: UIView!
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var txtCVC: UITextField!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    var picker : UIPickerView!
    var PickerView : UIPickerView!

    var jTableView : ActionPickerController? {
        didSet{
            PickerView?.dataSource = jTableView
            PickerView?.delegate = jTableView
            PickerView?.reloadAllComponents()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCheck.setImage(#imageLiteral(resourceName: "ic_checkbox_selected"), for: .selected)
        if Constants.CurrentUserData.connect_id == ""{
            self.viewVerified.isHidden = true

        }
        else{
            txtCardNumber.text = Constants.CurrentUserData.connect_id
            self.viewVerified.isHidden = false
            self.btnCheck.isSelected = true
        }
       
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    
    @IBAction func ExpDate(_ sender: UIButton) {
        let months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        var year = [String]()
        for i in 0...20{
            year.append("\(Date().get(.year) + i)")
        }
        jTableView = ActionPickerController.init(array: [months,year], title: txtExpDate.placeholder ?? "Select", picker: PickerView, viewController: self, sender: sender, configureCellBlock: { (arr, index, status) in
            if arr.count == 2{
                self.txtExpDate.text = arr[0] + "/" + arr[1]
            }
            
        })
    }
    @IBAction func cvc(_ sender: Any) {
    }
    @IBAction func Check(_ sender: Any) {
        btnCheck.isSelected = !btnCheck.isSelected
        
    }
    @IBAction func GetConnectID(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_M8KXmd9tHa8PkrrgNgyzRXfEdJMWAqMg&scope=read_write")!)
    }
    @IBAction func Continue(_ sender: Any) {
        if txtCardNumber.CheckText() {
            
//            code=4554&state=4545

            let dict = ["code" : txtCardNumber.text!,
                        "state" : "\(Constants.CurrentUserData.id)".toBase64()
                                               
            ] as [String : Any]
            
            APIClients.POST_updateConnect(parems: dict , storyBoard: storyboard!, navigation: self) { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    Constants.Toast.MyToast(message: response.message   )
                    self.viewVerified.isHidden = false
                    self.btnCheck.isSelected = true
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
    }
    @IBAction func Skip(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SeniorAddImageViewController") as! SeniorAddImageViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
extension AddCardViewController : UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return 12
        }
        return 20
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return "\(row + 1)"
        }
        return "\(Date().get(.year) + row)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtExpDate.text = "\(row + 1)/\(Date().get(.year) + row)"
    }
}
extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}
