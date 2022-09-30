//
//  GiveReviewViewController.swift
//  Alto
//
//  Created by Jaypreet on 09/12/21.
//

import UIKit
import Cosmos

class GiveReviewViewController: UIViewController {
    @IBOutlet weak var viewRate: CosmosView!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnOnTime: UIButton!
    @IBOutlet weak var btnGood: UIButton!
    @IBOutlet weak var btnNice: UIButton!
    var Request : M_Request_Data!
    var Enjoy : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNice.setImage(#imageLiteral(resourceName: "ic_nice_normal"), for: .normal)
        btnNice.setImage(#imageLiteral(resourceName: "ic_nice_selected-1"), for: .selected)
        btnGood.setImage(#imageLiteral(resourceName: "ic_conversation_normal"), for: .normal)
        btnGood.setImage(#imageLiteral(resourceName: "ic_conversation_selected"), for: .selected)
        btnOnTime.setImage(#imageLiteral(resourceName: "ic_on_time_normal"), for: .normal)
        btnOnTime.setImage(#imageLiteral(resourceName: "ic_on_time_selected"), for: .selected)
        
        btnYes.setImage(#imageLiteral(resourceName: "radio_button_off-1"), for: .normal)
        btnYes.setImage(#imageLiteral(resourceName: "radio_button_on"), for: .selected)
        btnNo.setImage(#imageLiteral(resourceName: "radio_button_off-1"), for: .normal)
        btnNo.setImage(#imageLiteral(resourceName: "radio_button_on"), for: .selected)
        btnYes.isSelected = true
        btnNo.isSelected = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func EnjoyLevel(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            btnNice.isSelected = !btnNice.isSelected
            if Enjoy.contains("1"){
                Enjoy.remove(at: Enjoy.firstIndex(of: "1") ?? 0)

            }
            else{
                Enjoy.append("1")
            }
            break
        case 2:
            btnGood.isSelected = !btnGood.isSelected
            if Enjoy.contains("2"){
                Enjoy.remove(at: Enjoy.firstIndex(of: "2") ?? 0)

            }
            else{
                Enjoy.append("2")
            }
            break
        case 3:
            btnOnTime.isSelected = !btnOnTime.isSelected
            if Enjoy.contains("3"){
                Enjoy.remove(at: Enjoy.firstIndex(of: "3") ?? 0)

            }
            else{
                Enjoy.append("3")
            }
            break
        default:
            break
        }
        
        
    }
    @IBAction func Continue(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "GiveReviewDetailViewController") as! GiveReviewDetailViewController
        vc.Enjoy = Enjoy.joined(separator: ",")
        vc.isReSchedule = btnYes.isSelected ? 1 : 0
        vc.Rate = viewRate.rating
        vc.Request = Request
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func Schedule(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            btnYes.isSelected = true
            btnNo.isSelected = false
            break
        case 2:
            btnYes.isSelected = false
            btnNo.isSelected = true
            break
   
        default:
            break
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
