//
//  J.DropDown.swift
//  Stopdigging
//
//  Created by Jaypreet on 03/08/20.
//  Copyright © 2020 Jaipreet. All rights reserved.
//

import Foundation
import UIKit

typealias  J_DropDownConfigureBlock = (_ text : String , _ Index : Int? , _ Status : String?  ) -> ()


class J_DropDownController  : NSObject ,  UITableViewDelegate, UITableViewDataSource{

    
    var tableView = UITableView()
    var configureCellBlock : J_DropDownConfigureBlock?
    var viewController : UIViewController!
    var sender : UIView!
    var Dictionary = [String]()
    var Title : String = ""
    var SelectedTitle : String = ""
    var Index : Int = 0
    var tempDictionary = [String]()
    var bgView : UIView!
    init (array : [String], title : String ,picker : UITableView? , viewController : UIViewController? , sender : UIView? , configureCellBlock : J_DropDownConfigureBlock?) {
        self.viewController = viewController
        self.configureCellBlock = configureCellBlock
        self.sender = sender
        self.Title = title
        super.init()
        self.Dictionary = array
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        for i in  array{
            tempDictionary.append(i)
        }
        CreateView()
    }
  
    override init() {
        super.init()
    }
     func CreateView()  {
        bgView = UIView.init(frame: CGRect.init(x: self.sender.frame.origin.x, y: self.sender.frame.origin.y, width:  self.sender.frame.size.width, height: CGFloat(tempDictionary.count * 40)))
        bgView.layer.cornerRadius = 4
        bgView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bgView.layer.shadowRadius = 2
        bgView.layer.shadowOpacity = 2
        bgView.addSubview(tableView)
        viewController.view.addSubview(bgView)
        viewController.view.bringSubviewToFront(bgView)
        UpdateHeight()
    }
    func UpdateHeight()  {
        if tempDictionary.count * 40 >= 200{
            bgView.frame.size.height = 200
        }
        else{
            bgView.frame.size.height = CGFloat(tempDictionary.count * 40)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempDictionary.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bgView.removeFromSuperview()
        if let block = self.configureCellBlock {
            block(tempDictionary[indexPath.row] , Index, "Done")
        }
    }
}

