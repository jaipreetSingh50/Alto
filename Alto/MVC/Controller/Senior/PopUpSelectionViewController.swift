//
//  PopUpSelectionViewController.swift
//  Alto
//
//  Created by Jaypreet on 15/11/21.
//

import UIKit

protocol selectedItemsPopupDelegate {
    func SelectedPopUp(arr : [String] , type : Int)
}

class PopUpSelectionViewController: UIViewController , UISearchBarDelegate {
    var delegate : selectedItemsPopupDelegate!
    var ArrayValues = [String]()
    var tempArrayValues = [String]()

    var SelectedValues = [String]()
    var ViewTitle : String = ""
    var ViewType : Int = 0
    var isSingleSelection : Bool = false

    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = ViewTitle
        tempArrayValues = ArrayValues
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Cancel(_ sender: Any) {
        Dismiss(false)
    }
    @IBAction func Done(_ sender: Any) {
        Dismiss(false) {
            self.delegate.SelectedPopUp(arr: self.SelectedValues, type: self.ViewType)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if txtSearch.text! == ""{
            ArrayValues = tempArrayValues
            tableView.reloadData()
        }
        else{
            ArrayValues = tempArrayValues.filter({ ($0.uppercased().contains(searchText.uppercased()))})
            tableView.reloadData()

        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        txtSearch.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        txtSearch.resignFirstResponder()

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        txtSearch.resignFirstResponder()

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
extension PopUpSelectionViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayValues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.textLabel?.text = ArrayValues[indexPath.row]
        if SelectedValues.contains(ArrayValues[indexPath.row]){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSingleSelection {
            SelectedValues.removeAll()
            SelectedValues.append(ArrayValues[indexPath.row])

        }
        else{
            if SelectedValues.contains(ArrayValues[indexPath.row]){
                SelectedValues.remove(at: SelectedValues.firstIndex(of: ArrayValues[indexPath.row])!)
            }
            else{
                SelectedValues.append(ArrayValues[indexPath.row])
                
            }
        }
        tableView.reloadData()
    }
}
