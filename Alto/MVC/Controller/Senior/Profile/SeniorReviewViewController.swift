//
//  SeniorReviewViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class SeniorReviewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    
    var ViewType : Int = 0
    
    
    @IBOutlet weak var c_Review_h: NSLayoutConstraint!
    @IBOutlet weak var viewReview: UIView!
    var User_id : Int = 0
    var ReviewCollection = [M_Review_Data]()
    override func viewDidLoad() {
        super.viewDidLoad()
        c_Review_h.constant = 0
        viewReview.isHidden = true
        if ViewType == 0{
            imgUser.getImage(url: Constants.CurrentUserData.image!)
            c_Review_h.constant = 0
            viewReview.isHidden = true
            ApiGetReviews(id : Constants.CurrentUserData.id)
        }
        else{
            ApiGetReviews(id : User_id)

            imgUser.getImage(url: Constants.CurrentUserData.image!)

        }
        
        tableView.RegisterTableCell("ReviewTableViewCell")
        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func Review(_ sender: Any) {
        
    }
    func ApiGetReviews(id : Int) {
        let dict = ["user_id" : id,
                    
                    ]
        
        APIClients.POST_user_getReview(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.ReviewCollection = response.data
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
extension SeniorReviewViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReviewCollection.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        cell.selectionStyle = .none
        cell.lblName.text = ReviewCollection[indexPath.row].user_data.full_name
        cell.lblReview.text = ReviewCollection[indexPath.row].detail
        cell.imgUser.getImage(url: ReviewCollection[indexPath.row].user_data.image ?? "")
        cell.viewReview.rating = Double(ReviewCollection[indexPath.row].rate) ?? 0
        let enjoy = ReviewCollection[indexPath.row].enjoy.components(separatedBy: ",")
        cell.btnLike.setImage(#imageLiteral(resourceName: "ic_nice_normal"), for: .normal)
        cell.btnLike.setImage(#imageLiteral(resourceName: "ic_nice_selected-1"), for: .selected)
        cell.btnGood.setImage(#imageLiteral(resourceName: "ic_conversation_normal"), for: .normal)
        cell.btnGood.setImage(#imageLiteral(resourceName: "ic_conversation_selected"), for: .selected)
        cell.BtnBest.setImage(#imageLiteral(resourceName: "ic_on_time_normal"), for: .normal)
        cell.BtnBest.setImage(#imageLiteral(resourceName: "ic_on_time_selected"), for: .selected)
        if enjoy.contains("1"){
            cell.btnLike.isSelected = true
            
        }
        else{
            cell.btnLike.isSelected = false

        }
        if enjoy.contains("2"){
            cell.btnGood.isSelected = true
            
        }
        else{
            cell.btnGood.isSelected = false

        }
        if enjoy.contains("3"){
            cell.BtnBest.isSelected = true
            
        }
        else{
            cell.BtnBest.isSelected = false

        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

