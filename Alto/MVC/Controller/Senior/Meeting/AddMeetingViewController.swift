//
//  AddMeetingViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit
import IQKeyboardManagerSwift




class AddMeetingViewController: UIViewController {

 
    @IBOutlet weak var txtOther: IQTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var Category_List = [M_Categories_data]()
    var SelectedCat = [String]()
    var SelectedLang = [String]()
    var Language : String = ""
    var MeetingType : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = Constants.CurrentUserData.full_name
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

            // layout.itemSize = CGSize(width: 90, height: 45)
        collectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.GetCAtegory { (list) in
            self.Category_List.removeAll()
            if self.MeetingType == AppMeetingType.Online.value(){
                self.Category_List = list.categories.online.data

            }
            else{
                self.Category_List = list.categories.offline.data

            }
            self.collectionView.reloadData()
        }
    }
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    @IBAction func Continue(_ sender: Any) {
       
        if SelectedCat.count == 0 && txtOther.text! == ""{
            return
        }
        let vc = storyboard?.instantiateViewController(identifier: "MeetingDateViewController") as! MeetingDateViewController
        vc.Language = SelectedLang.joined(separator: ",")
        vc.MeetingType = MeetingType
        if txtOther.text.isEmpty{
            vc.Tags = SelectedCat.joined(separator: ",")
        }
        else{
            vc.Tags = SelectedCat.joined(separator: ",") + "," + txtOther.text!
        }
        navigationController?.pushViewController(vc, animated: true)
        
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

extension AddMeetingViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return Category_List.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let vie = cell.viewWithTag(1)!
        let lbl = cell.viewWithTag(2) as! UILabel
        lbl.text = Category_List[indexPath.row].name
        if SelectedCat.contains(Category_List[indexPath.row].name){
            lbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vie.backgroundColor = #colorLiteral(red: 0.009299149737, green: 0.2921254039, blue: 0.628552258, alpha: 1)
        }
        else{
            vie.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if SelectedCat.contains(Category_List[indexPath.row].name){
            SelectedCat.remove(at: SelectedCat.firstIndex(of: Category_List[indexPath.row].name)!)
        }
        else{
            SelectedCat.append(Category_List[indexPath.row].name)
        }
        
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return NSCoder.cgSize(for: Category_List[indexPath.row].name)
    
        return CGSize.init(width: Category_List[indexPath.row].name.width(withConstrainedHeight: 40, font: UIFont.boldSystemFont(ofSize: 15) ) + 20, height: 40)
    }

}
