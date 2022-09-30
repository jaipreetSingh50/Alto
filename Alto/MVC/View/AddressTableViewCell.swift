//
//  AddressTableViewCell.swift
//  Alto
//
//  Created by Jaypreet on 08/12/21.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
