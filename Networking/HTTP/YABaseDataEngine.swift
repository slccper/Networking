//
//  BaseDataEngine.swift
//  Networking
//
//  Created by Su on 16/5/10.
//  Copyright © 2016年 nesting. All rights reserved.
//

import Foundation

class YABaseDataEngine: NSObject{
    var requestId:Int!
    
    deinit{
        cancelRequest()
    }
    class func test(Controll controll : NSObject,Path path: String,Param parameters: [String : AnyObject],complete responseBlock:@escaping ([String:AnyObject],Error?)->())-> YABaseDataEngine{
        return self.callAPIWith(Controll: controll, Path: path, Param: parameters, RequesrType: .YAAPIManagerRequestTypeGet, AlertType: .dataEngineAlertType_None, complete: responseBlock)
    }
    class func callAPIWith(Controll controll : NSObject,Path path: String,Param parameters: [String : AnyObject],RequesrType requesrType: YAAPIManagerRequestType,ServiceType serviceType: YAAPIManagerServiceType = .service1,Version version: APIServerVersion = .V1,AlertType alertType: DataEngineAlertType,Header header:YAAPIManagerHeaders = .HeaderJson,complete responseBlock:@escaping ([String:AnyObject],Error?)->()) -> YABaseDataEngine{
        
        let engine :YABaseDataEngine = YABaseDataEngine()
        weak var weakControll  = controll
        let dataModel :YAAPIBaseRequestDataModel = engine.dataModelWith(Path: path, Param: parameters, RequestType: requesrType, DataFilePath: nil,ServiceType:serviceType,Version:version,Header:header,DataName: nil, MimeType: nil, FileName: nil,complete:{
            (data,error)in
            if weakControll != nil && engine.requestId != nil{
                weakControll!.networkingAutoCancelRequests!.removeEngineWithRequestID(engine.requestId)
            }
            if weakControll != nil {
                dispatch_sync_safely_main_queue({
                    responseBlock(data,error)
                })
            }
            })
        engine .callRequestWith(dataModel, Control: weakControll!)
        return engine;
    }

    /**
     模型数据初始化
     
     - parameter serviceType:   服务器标识
     - parameter path:          方法
     - parameter parameters:    参数键值对
     - parameter requestType:   请求方式
     - parameter dataFilePath:  上传文件路径
     - parameter dataName:      数据名称
     - parameter mimeType:      文件类型
     - parameter fileName:      文件名称
     - parameter responseBlock: 响应数据
     
     - returns: 返回模型实例
     */
    func dataModelWith(Path path: String,Param parameters: [String : AnyObject],RequestType requestType: YAAPIManagerRequestType?,DataFilePath dataFilePath:String?,ServiceType serviceType: YAAPIManagerServiceType,Version version: APIServerVersion,Header header:YAAPIManagerHeaders, DataName dataName : String?,MimeType mimeType:String?,FileName fileName : String?,complete responseBlock: @escaping ([String:AnyObject],Error?)->()) ->YAAPIBaseRequestDataModel {
        let dataModel :YAAPIBaseRequestDataModel = YAAPIBaseRequestDataModel()
        dataModel.apiMethodPath=path
        dataModel.parameters = parameters
        dataModel.dataFilePath = dataFilePath
        dataModel.dataName = dataName
        dataModel.mimeType = mimeType
        dataModel.requestType = requestType
        dataModel.fileName = fileName
        dataModel.serviceType = serviceType
        dataModel.version = version
        dataModel.responseBlock=responseBlock
        dataModel.header = header
        return dataModel;
    }
    
    func callRequestWith(_ dataModel: YAAPIBaseRequestDataModel,Control control: NSObject) -> () {
        self.requestId=YAAPIClient.sharedInstance.callRequest(dataModel);
        control.networkingAutoCancelRequests?.setEngine(self,RequestID: self.requestId)
    }
    
    func cancelRequest(){
        if self.requestId != nil {
            YAAPIClient.sharedInstance.cancelRequestWithRequestID(self.requestId)
        }
        
    }
}


