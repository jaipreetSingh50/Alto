//
//  NewBookingTableViewCell.swift
//  Alto
//
//  Created by Jaypreet on 01/11/21.
//

import UIKit

class NewBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblBookingNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblTypeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
