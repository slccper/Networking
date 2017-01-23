//
//  YAAPIBaseRequestDataModel.swift
//  Networking
//
//  Created by Su on 16/5/12.
//  Copyright © 2016年 nesting. All rights reserved.
//

import Foundation
import Alamofire
class YAAPIBaseRequestDataModel: NSObject {
    var apiMethodPath :String!
    var parameters : Dictionary<String,AnyObject>!
    var requestType :YAAPIManagerRequestType?
    var serviceType :YAAPIManagerServiceType?
    var version :APIServerVersion?
    var header : YAAPIManagerHeaders?
    var dataFilePath :String?
    var dataName : String?
    var fileName : String?
    var mimeType :String?
    var responseBlock :([String:AnyObject],Error?)->()?={(data,error)->() in
        IBprint("data=\(data),error=\(error)")
    }
    var method :HTTPMethod! {
        get{
            switch requestType! {
            case YAAPIManagerRequestType.YAAPIManagerRequestTypeGet:
                return .get
            case YAAPIManagerRequestType.YAAPIManagerRequestTypePost:
                return .post
            case YAAPIManagerRequestType.YAAPIManagerRequestTypePostUpload:
                return .post
            case YAAPIManagerRequestType.YAAPIManagerRequestTypePUT:
                return .put
            case YAAPIManagerRequestType.YAAPIManagerRequestTypeDELETE:
                return .delete
            case YAAPIManagerRequestType.YAAPIManagerRequestTypeGETDownload:
                return .get
            }
        }
    }
    override init() {
        super.init()
    }
    func convertDataToDictionary(_ data: Data?) -> Dictionary<String,AnyObject> {
        var json : Dictionary<String,AnyObject>!
        
        do{
            let dic = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers)
            guard let dicdata = dic as? [String:Any]else {
                guard let arrdata = dic as?[AnyObject] else {
                    json = ["code":200 as AnyObject,"message":"无法获取数据！" as AnyObject] //数据格式不对时显示
                    return json
                }
                json = ["code":0 as AnyObject,"message":"" as AnyObject,"result":arrdata as AnyObject]
                return json
            }
            guard ((dicdata["code"]as? Int) != nil) else{
                json = ["code":0 as AnyObject,"message":"" as AnyObject,"result":dicdata as AnyObject]
                return json
            }
            json = dicdata as Dictionary<String, AnyObject>!
        }catch {
            json = ["code":200 as AnyObject,"message":"无法获取数据！"as AnyObject] //数据格式不对时显示
        }
        return json
            }
    class func errorHandlerWith(_ requestDataModel: YAAPIBaseRequestDataModel,Data data: Data?,Error error: Error?)->(){
        var json = requestDataModel.convertDataToDictionary(data)
        if error != nil{
            requestDataModel.responseBlock(json,error)
        }else{
            guard let code = json["code"]as? Int else{
                requestDataModel.responseBlock(["code":200 as AnyObject,"message":"数据格式错误！" as AnyObject],error)
                return
            }
            if code == ErrorCode.errorOfAccesstokenInvalid.rawValue || code == ErrorCode.errorOfAccesstokeneExpire.rawValue {
            }else if  code == ErrorCode.errorOfRefreshtokenInvalid.rawValue || code == ErrorCode.errorOfRefreshtokenExpire.rawValue {
                
            }else{
                requestDataModel.responseBlock(json,error)
            }
            
            
        }
    }
}
