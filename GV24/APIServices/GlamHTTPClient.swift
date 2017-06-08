//
//  GlamHTTPClient.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Alamofire
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


//class GlamHttpClient {
//    var completeQueue:DispatchQueue {
//        return DispatchQueue.global()
//    }
//    
//    func makeRequest(_ method: Alamofire.Method,
//                     URLString: String,
//                     encoding: ParameterEncoding,
//                     headers: [String: String]?,
//                     parameters: [String : AnyObject]?,
//                     completionHandler: @escaping(DataResponse<Any>) -> Void) {
//        
//        Alamofire.request(method, URLString, encoding: encoding,headers: headers, parameters: parameters)
//            .validate()
//            .responseJSON(queue: completeQueue) { (response) in
//                
//                completionHandler(response)
//        }
//    }
//    
//    func requestAPI(_ method: Alamofire.Method,
//                    URLString: String,
//                    conditions:Dictionary<String,AnyObject>?,
//                    completionHandler: @escaping (_ data:Dictionary<String,AnyObject>) -> Void,
//                    errorHandler: @escaping (_ error:GlamError?) -> Void) {
//        var header:[String: String]?
//        if isLogged {
//            header = ["Token": UserDefaultHelper.getUserToken(), "LoggedUserId":UserDefaultHelper.getUserID()]
//        }
//        
//        self.makeRequest(method, URLString: URLString, encoding: .url, headers: header, parameters: conditions) { (response) in
//            switch response.result {
//            case .success:
//                guard let jsonData = response.result.value as? Dictionary<String, AnyObject> else {
//                    //error convert response to Dictionary
//                    var errorConvertJson:GlamError = GlamError()
//                    errorConvertJson.errorCode = 999
//                    errorConvertJson.errorContent = "ERROR"
//                    errorHandler(error: errorConvertJson)
//                    errorHandler(error: GlamError())
//                    return
//                }
//                completionHandler(data: jsonData)
//                break
//                
//            case .failure:
//                var glamEror:GlamError = GlamError()
//                if 200 <= response.response?.statusCode && response.response?.statusCode <= 300 {
//                    glamEror.errorCode = 200
//                    glamEror.errorContent = "Success with nil data"
//                } else {
//                    guard let jsonErrorData = response.result.value as? Dictionary<String,AnyObject> else {
//                        glamEror.errorCode = 999
//                        glamEror.errorContent = "ERROR"
//                        return
//                    }
//                    if let data = jsonErrorData["error"] as? [String: AnyObject] {
//                        glamEror = GlamError(JSON: data)!
//                    }
//                }
//                errorHandler(error: glamEror)
//                break
//            }
//        }
//    }
//}
