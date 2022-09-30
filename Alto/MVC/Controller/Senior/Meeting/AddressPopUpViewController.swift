//
//  AddressPopUpViewController.swift
//  Alto
//
//  Created by Jaypreet on 30/11/21.
//

import UIKit

protocol  AddressPopupDelegate {
    func SelectAddress(id : Int )
    func SelectNewAddress()
}

class AddressPopUpViewController: UIViewController {
    var delegate : AddressPopupDelegate!
    @IBOutlet weak var tableView: UITableView!
    var AddressID : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    @IBAction func Close(_ sender: Any) {
        Dismiss(false)
    }
    @IBAction func Addnew(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SeniorSignup3ViewController") as! SeniorSignup3ViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isNewAddress = true
        self.present(vc, animated: true, completion: nil)
//        Dismiss(false) {
//            self.delegate.SelectNewAddress()
//        }
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
extension AddressPopUpViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.CurrentUserData.address?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let address = "\(Constants.CurrentUserData.address?[indexPath.row].complete_address ?? ""), \(Constants.CurrentUserData.address?[indexPath.row].address ?? "")\n\(Constants.CurrentUserData.address?[indexPath.row].city ?? ""),\(Constants.CurrentUserData.address?[indexPath.row].state ?? ""),\n\(Constants.CurrentUserData.address?[indexPath.row].country ?? ""), \n\(Constants.CurrentUserData.address?[indexPath.row].zip_code ?? "")"
            
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = address
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Dismiss(false) {
            self.delegate.SelectAddress(id: Constants.CurrentUserData.address?[indexPath.row].id ?? 0)
        }
    }
}
