

//
//  YAAPIClient.swift
//  Networking
//
//  Created by Su on 16/5/12.
//  Copyright © 2016年 nesting. All rights reserved.
//

import Foundation
import Alamofire

class YAAPIClient: NSObject{
    static let sharedInstance = YAAPIClient()
    var dispatchTable :Dictionary<Int,Request> = [ : ]
    var requestModelDict :Dictionary<Int,YAAPIBaseRequestDataModel> = [ : ]
    var netWorkManager :NetworkReachabilityManager
    var manager :SessionManager!
    //网络监听
    override init() {
        netWorkManager = NetworkReachabilityManager()!
        netWorkManager.listener = { status in
            IBprint("Network Status Changed")
        }
        netWorkManager.startListening()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        manager = SessionManager(configuration: configuration)
    }
    
    func callRequest(_ requestModel : YAAPIBaseRequestDataModel) -> Int {
        let MOBILE_CLIENT_HEADERS = ["Content-Type":(requestModel.header?.rawValue)!,"charset":"UTF-8"]
        let request:DataRequest!
        let themethod = getmethod(requestModel)
        if requestModel.requestType == .YAAPIManagerRequestTypePostUpload {
             let data = requestModel.parameters["icon"]as!Data
             request = manager.upload(data, to: themethod, method: .post, headers: MOBILE_CLIENT_HEADERS)
        }else{
             request = manager.request(themethod, method: requestModel.method, parameters: requestModel.parameters, encoding: URLEncoding.default, headers: MOBILE_CLIENT_HEADERS)
        }
       
        request.response { (respon) in
            let stringdata :String = String.init(data: respon.data!, encoding: String.Encoding.utf8)!
            IBprint(themethod+"  response:"+stringdata)
            var message = respon.data
            if !self.netWorkManager.isReachable {
                let msg :Dictionary<String,AnyObject> = ["code":300 as AnyObject,"message":"网络不稳定，请稍后再试！" as AnyObject]
                IBprint(msg.description)
                do{
                    message = try JSONSerialization.data(withJSONObject: msg, options: .prettyPrinted)
                }catch{
                    IBprint("catch")
                }
            }
            YAAPIBaseRequestDataModel.errorHandlerWith(requestModel, Data: message, Error: respon.error)
        }
       
        let requestID :Int = request.task!.hash
        self.dispatchTable[requestID] = request;
        return requestID
    }
    fileprivate func getmethod(_ requestModel :YAAPIBaseRequestDataModel)->String{
        let method :String!
        
        method = requestModel.serviceType!.rawValue + requestModel.version!.rawValue + requestModel.apiMethodPath
        
        IBprint(method + " " + requestModel.requestType!.rawValue)
        IBprint(requestModel.parameters)
        return method
    }
    //图片上传
    func callUpload(_ requestModel : YAAPIBaseRequestDataModel){
        let MOBILE_CLIENT_HEADERS = ["charset":"UTF-8"]
        let method = getmethod(requestModel)
        let data = requestModel.parameters["icon"]as!Data
        manager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "icon", fileName: "headimg.png", mimeType: "image/png")
            }, to: method,method:.post,
               headers: MOBILE_CLIENT_HEADERS) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            IBprint(value)
                        case .failure(let error):
                            IBprint(error)
                        }
                        let stringdata :String = String.init(data: response.data!, encoding: String.Encoding.utf8)!
                        IBprint(method+"  response:"+stringdata)
                        YAAPIBaseRequestDataModel.errorHandlerWith(requestModel, Data: response.data, Error: response.result.error)
                    }
                case .failure(let encodingError):
                    IBprint(encodingError)
                }
        }
    }
    func cancelAll(){
        for request in self.dispatchTable{
            request.1.cancel()
        }
    }
    func reloadAll(){
        for request in self.dispatchTable{
            request.1.resume()
        }
    }
    func cancelRequestWithRequestID(_ requestID:Int) -> () {
        let request:Request = self.dispatchTable[requestID]!
        request.cancel()
        self.dispatchTable.removeValue(forKey: requestID)
    }
    
    func cancelRequestWithRequestIDList(_ requestIDList : Array<Int>) -> () {
        for requestID in requestIDList{
            self.cancelRequestWithRequestID(requestID)
        }
    }
}
