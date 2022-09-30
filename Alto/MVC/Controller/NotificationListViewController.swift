//
//  NotificationListViewController.swift
//  Alto
//
//  Created by Jaypreet on 14/12/21.
//

import UIKit

class NotificationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    var  CollectionNotification = [M_Notification_Data]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("NotificationTableViewCell")
        GetNotificationList()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    func GetNotificationList()  {
        let dict = ["" : "",
                    ]
        
        APIClients.POST_user_notification_list(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.CollectionNotification = response.data
                self.tableView.reloadData()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
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
extension NotificationListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CollectionNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.selectionStyle = .none
        let dict = CollectionNotification[indexPath.row]
        cell.imgUser.getImage(url: dict.user_image)
        cell.lblTitle.text = dict.title
        cell.lblUserName.text = "By: \(dict.user_name)"
        cell.lblDetail.text = dict.description
        cell.lblDate.text = dict.created_at.getTimeFromTime(currentFormat: DateFormat.yyyy_MM_dd_hh_mm_a.get(), requiredFormat: DateFormat.fullDataWithday.get())
        
        return cell
    }
}
