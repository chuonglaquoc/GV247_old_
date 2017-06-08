//
//  WorkerViewCell.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class WorkerViewCell: UITableViewCell {

    @IBOutlet weak var ownerComment: UILabel!
    @IBOutlet weak var ownerAddress: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var arrowForward: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        arrowForward.image = Ionicons.iosArrowForward.image(18, color: UIColor.lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
