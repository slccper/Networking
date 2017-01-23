//
//  ViewController.swift
//  Networking
//
//  Created by Su on 16/5/10.
//  Copyright © 2016年 Su. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

   
     deinit{
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let param :Dictionary = ["rnd":"250B6B28E6DC877C45CD1B3C89FEE534","data":"%7B%7D"] 
       
        let _ = YABaseDataEngine.test(Controll: self, Path: "mtop.common.getTimestamp", Param: param as [String : AnyObject], complete: {
            (dic, error) in
            print(dic)
        })
    }
}
