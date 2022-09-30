//
//  EmptyListTableViewCell.swift
//  Modo Customer
//
//  Created by Jaypreet on 01/10/19.
//  Copyright © 2019 Jaypreet. All rights reserved.
//

import UIKit

class EmptyListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnReload: UIButton!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblEmpty: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
