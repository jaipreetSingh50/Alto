//
//  SetTimeTableViewCell.swift
//  Alto
//
//  Created by Jaypreet on 30/12/21.
//

import UIKit

class SetTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var endTime: UIDatePicker!
    
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var lblMeetingDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
