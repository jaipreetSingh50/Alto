//
//  SeniorDetailViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class SeniorDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var imgUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("AddressTableViewCell")
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func AddNewAddress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SeniorSignup3ViewController") as! SeniorSignup3ViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isNewAddress = true
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    @IBAction func Continue(_ sender: Any) {
       dismiss()
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
extension SeniorDetailViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.CurrentUserData.address?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.selectionStyle = .none
        let address = "\(Constants.CurrentUserData.address?[indexPath.row].complete_address ?? ""), \(Constants.CurrentUserData.address?[indexPath.row].address ?? "")\n\(Constants.CurrentUserData.address?[indexPath.row].city ?? "")\n\(Constants.CurrentUserData.address?[indexPath.row].state ?? ""), \(Constants.CurrentUserData.address?[indexPath.row].country ?? ""),\n\(Constants.CurrentUserData.address?[indexPath.row].zip_code ?? "")"
        cell.lblAddress.text = address
        cell.btnDelete.addTarget(self, action: #selector(Self.DeleteAdd(_:)), for: .touchDown)
        cell.btnDelete.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    @IBAction func DeleteAdd(_ sender: UIButton) {
        DeleteAddress(id :  Constants.CurrentUserData.address?[sender.tag].id ?? 0, index: sender.tag)
    }
    func DeleteAddress(id : Int , index : Int)  {
        let dict = ["address_id" : id,
                    ]
        
        APIClients.POST_user_userdeleteAddress(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.CurrentUserData.address?.remove(at: index)
                self.tableView.reloadData()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }

}
