//
//  HistoryViewCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class HistoryViewCell: UITableViewCell {

    @IBOutlet weak var timeWork: UILabel!
    @IBOutlet weak var startAt: UILabel!
    @IBOutlet weak var workNameLabel: UILabel!
    @IBOutlet weak var iconAlarm: UIImageView!
    @IBOutlet weak var imageWork: UIImageView!
    @IBOutlet weak var estimateTimeFinished: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageWork.layer.cornerRadius = imageWork.frame.width/2
        imageWork.clipsToBounds = true
        iconAlarm.tintColor = UIColor(red: 172, green: 224, blue: 227, alpha: 1)
        let icon = Ionicons.iosAlarm.image(12)
        iconAlarm.image = icon
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
