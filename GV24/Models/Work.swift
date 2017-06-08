//
//  Work.swift
//  GV24
//
//  Created by HuyNguyen on 5/27/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Work: AppModel {
    var id:String?
    var history:[String:Any]?
    var stakeholders:[String:Any]?
    var info:Info?
    var workTime: [String:Any]?
    var contentDescription: String?
    var price: Int?
    var address:Address?
    var ownerInfo: Owner?
    
    override init(json:JSON) {
        super.init()
        self.id = json["_id"].string
        self.history = json["history"].dictionary
        self.info = Info(json: json["info"])
        self.workTime = json["info"]["time"].dictionary
        self.contentDescription = json["info"]["description"].string
        self.price = json["info"]["price"].int
        self.address = Address(json: json["info"]["address"])
        self.ownerInfo = Owner(json: json["stakeholders"]["owner"])
    }
}
