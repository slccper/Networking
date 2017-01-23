//
//  YANetworkingAutoCancelRequests.swift
//  Networking
//
//  Created by Su on 16/5/12.
//  Copyright © 2016年 nesting. All rights reserved.
//

import Foundation


class YANetworkingAutoCancelRequests: NSObject {
    var requestEngines : Dictionary<Int,YABaseDataEngine> = [:]
    func setEngine(_ engine : YABaseDataEngine,RequestID requestID : Int) -> () {
        requestEngines[requestID] = engine
    }
    func removeEngineWithRequestID(_ requestID:Int) -> () {
        requestEngines[requestID] = nil
    }
    deinit{
        requestEngines.removeAll()
    }
}
