//
//  ReviewTableViewCell.swift
//  Alto
//
//  Created by Jaypreet on 27/10/21.
//

import UIKit
import Cosmos
class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var BtnBest: UIButton!
    @IBOutlet weak var btnGood: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var viewReview
        : CosmosView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
