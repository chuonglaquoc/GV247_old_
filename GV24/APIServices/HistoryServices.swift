//
//  HistoryServices.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HistoryServices: APIService {
    
    static let sharedInstance = HistoryServices()
    
    func getWorkHistoryWith(url:String,param:Parameters,header:HTTPHeaders,completion:@escaping((JSON?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                completion(json, nil)
                break
            case .failure(let err):
                completion(nil, err)
                break
            }
        }
    }
    
}
