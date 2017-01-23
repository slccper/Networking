//
//  File.swift
//  Networking
//
//  Created by Su on 16/5/10.
//  Copyright © 2016年 nesting. All rights reserved.
//
import Foundation
enum YAAPIManagerRequestType :String{
    
    case YAAPIManagerRequestTypeGet = "GET"               //get请求
    case YAAPIManagerRequestTypePost = "POST"             //POST请求
    case YAAPIManagerRequestTypePostUpload = "POSTUPLOAD"       //POST数据请求
    case YAAPIManagerRequestTypeGETDownload = "GETDOWNLOAD"       //下载文件请求，不做返回值解析
    case YAAPIManagerRequestTypePUT = "PUT"
    case YAAPIManagerRequestTypeDELETE = "DELETE"
    
}
enum YAAPIManagerServiceType:String{
    case service1 = "http://www.baidu.com/"
    case service2 = "http://api.baidu.com/"
}

enum YAAPIManagerHeaders: String{
    case HeaderFromData = "multipart/form-data"
    case HeaderJson =  "application/json"
}

enum APIV1Server:String {
    case TestServerAPIV1 = "http://www.baidu.com/"
    case FormalServerAPIV1 = "http://api.baidu.com/"
    static let servers = [TestServerAPIV1,FormalServerAPIV1]
}
enum APIServerVersion :String {
    case V1 = "v1/"
    case V2 = "v2/"
}
enum App_IDs :String{
    case TestApp_ID = "999"
    case FormalApp_ID = "101"
    static let appids = [FormalApp_ID,FormalApp_ID]
}


enum ErrorCode:Int {
    case errorOfAccesstokenInvalid = 3001
    case errorOfAccesstokeneExpire = 3002
    case errorOfRefreshtokenInvalid = 3003
    case errorOfRefreshtokenExpire = 3004
    case errorOfNoAccount = 3005
}


enum  DataEngineAlertType {
    case dataEngineAlertType_None
    case dataEngineAlertType_Toast
    case dataEngineAlertType_Alert
    case dataEngineAlertType_ErrorView
}
func dispatch_sync_safely_main_queue(_ block: ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync() {
            block()
        }
    }
}
func IBprint(_ items: Any){
    #if DEBUG
        print("DEBUG:",items)
    #else
        
    #endif
}

