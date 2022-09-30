//
//  EarningViewController.swift
//  Alto
//
//  Created by Jaypreet on 29/10/21.
//

import UIKit

class EarningViewController: UIViewController {

    @IBOutlet weak var txtFilter: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("EarningTableViewCell")
        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
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
extension EarningViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningTableViewCell", for: indexPath) as! EarningTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
}
