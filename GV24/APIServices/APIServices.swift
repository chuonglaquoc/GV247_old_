//
//  APIServices.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


typealias ResponseCompletion = (JSON?, String?) -> ()
class APIService: NSObject {
    static let shared = APIService()
    func post(url : String, parameters: Parameters,header:[String:Any], completion: @escaping ((JSON?, Error?)->())){
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json, nil)
            case .failure(let error):
                completion(nil, error)
                print(error)
            }
        }
    }
    func postMultipart(url : String, image: UIImage?, name: String?, parameters: Dictionary<String, String>, completion: @escaping (ResponseCompletion)){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in parameters{
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
        },
            to:url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = JSON(response.value as Any)
                        let status = json["status"].bool
                        if status == nil{
                        return
                        }
                        if status == false{
                            if let message = json["message"].string{
                                completion(nil, message)
                            }
                        }else{
                            completion(json["data"], nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    completion(nil, encodingError.localizedDescription)
                }
        })
    }
    func postLogin(url : String,method:HTTPMethod, parameters: [String:Any]?,encoding: JSONEncoding,header:[String:String], completion: @escaping ((JSON, Error?)->())){
        Alamofire.request(url, method:method,parameters: parameters, encoding: encoding, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                
                if !status!{
                    if let message = json["message"].string{
                        completion(nil, message as? Error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func postURL(url : String,method:HTTPMethod, parameters: Parameters,encoding: JSONEncoding,header:[String:String], completion: @escaping ((_ json:[WorkName]?,_ idString:String?,_ jsonInfo:[Info]?,_ jsonOwner:[Owner]?, Error?)->())){
        var idString:String?
        var workValue = [WorkName]()
        let infoValue = [Info]()
        var ownerDic = [Owner]()
        Alamofire.request(url, method:method,parameters: parameters, encoding: encoding, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if !status!{
                    if let message = json["message"].string{
                        completion(nil,"", nil, nil, message as? Error)
                    }
                }
                guard let data = json["data"]["docs"].array else{completion(nil,"",nil, nil,nil)
                    return}
                for i in data{
                    guard let id = i["_id"].string else{return}
                    print(id)
                    var a = i["info"].dictionary
                    let w = WorkName(json: json)
                    guard let b = a?["work"]?.dictionary else{return}
                    if let c = b["name"]?.string{w.name = c}
                    if let c = b["image"]?.string{ w.image = c}
                    workValue.append(w)
                    if let stackHolder = i["stakeholders"].dictionary{
                        ownerDic = [Owner(json: stackHolder["owner"])]
                        print(ownerDic)
                    }
                }
                completion(workValue,idString,infoValue ,ownerDic, nil)
            case .failure(let error):
                completion(nil,"",nil, nil, error.localizedDescription as? Error)
            }
        }
    }
    func owner() {
        
    }
    func posturl(url:String,parameters:Parameters,completion: @escaping ((JSON?,Error?)->())){
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json, nil)
                print("JSON: \(json)")
            case .failure(let error):
                completion(nil, error)
                print(error)
            }
        }
    }
    
    func getUrl(url:String,param:Parameters,header:HTTPHeaders,completion:@escaping((JSON?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if status == nil{return}
                if status == false{
                    if let message = json["message"].string{
                    completion(nil, message as? Error)
                    }
                }
                guard let data = json["data"].dictionary else{return}
                print(data)
                completion(json, nil)
            case .failure(let error):
                completion(nil, error)
                print(error)
            }
        }
    }
    func getOwner(url:String,param:Parameters,header:HTTPHeaders,completion:@escaping((JSON?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if status == nil{return}
                if status == false{
                    if let message = json["message"].string{
                        completion(nil, message as? Error)
                    }
                }
                guard let data = json["data"].dictionary else{return}
                print(data)
                completion(json, nil)
            case .failure(let error):
                completion(nil, error)
                print(error)
            }
        }
    }
    func getImageFromURL(url:String, completion:@escaping((_ imagString:UIImage?, _ error:Error?)->())) {
        Alamofire.download(url).responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data)
                completion(image, nil)
            }
        }
    }
}
class BaseService: NSObject {
    
    let apiService = APIService()
    
    override init() {
        super.init()
    }
    
    
}
