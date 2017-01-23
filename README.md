# Networking
基于Alamofire 的多服务器，多版本的swift网络库


调用方法：

let param = YARequestModel()
param.mobile = "123456789"
param.password = newpwd?.md5
let _ = YABaseDataEngine.test(Controll: self, Path: "mtop.common.getTimestamp", Param: param.getRequestDic(), complete: {
            (dic, error) in
            print(dic)
        })
