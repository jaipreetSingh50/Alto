//
//  PaymentTableViewCell.swift
//  Alto
//
//  Created by Jaypreet on 27/10/21.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblCardExpired: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
