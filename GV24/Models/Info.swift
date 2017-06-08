//
//  Info.swift
//  GV24
//
//  Created by HuyNguyen on 5/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class Info: AppModel {
    var title:String?
    var package:Package?
    var workName:WorkName?
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init()
        self.title  = json["title"].string
        self.workName = WorkName(json: json["work"])
    }
   
}
class Package: Info {
    var id:String?
    var name:String?

}

class WorkName:AppModel {
    var id:String?
    var image:String?
    var name:String?
    override init(json: JSON) {
        super.init(json: json)
        self.name = json["name"].string
        self.image = json["image"].string
    }
}
