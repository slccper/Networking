//
//  YARequestModel.swift
//  intbee
//
//  Created by Su on 16/5/20.
//  Copyright © 2016年 nesting. All rights reserved.
//

import Foundation

class YARequestModel :NSObject{
    var mobile :String?              //手机
    var password :String?            //md5(密码)
    var verify_code :String?         //手机验证密码
    var email :String?               //Email
    var username :String?            //用户手机或邮件
    var name :String?                //真实姓名
    //获取参数
    func getRequestDic()->Dictionary<String,AnyObject>{
        var dic : Dictionary<String,AnyObject> = [:]
        var count = 0 as  UInt32
        let ivars = class_copyPropertyList(self.classForCoder, &count)
        for index in 0..<Int(count){
            let ivar = ivars?[index]
            let name = property_getName(ivar)
            let key = String(cString: name!)
            if key != "" || !key.isEmpty{
                let value = self.value(forKey: key)
                if value != nil {
                    dic[key] = value as AnyObject?
                }
            }
        }
        free(ivars)
        return dic
    }
}
