//
//  NSObject+YANetWorkingAutoCancel.swift
//  Networking
//
//  Created by Su on 16/5/12.
//  Copyright © 2016年 Su. All rights reserved.
//

import Foundation
private var requestKey : Void?
extension NSObject{
    var networkingAutoCancelRequests :YANetworkingAutoCancelRequests?{
        get{
            var requests :YANetworkingAutoCancelRequests?
            requests = objc_getAssociatedObject(self, &requestKey) as? YANetworkingAutoCancelRequests
            if requests == nil {
                requests = YANetworkingAutoCancelRequests()
                objc_setAssociatedObject(self, &requestKey, requests, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return requests
        }
    }
}
