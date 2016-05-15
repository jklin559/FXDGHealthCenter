//
//  FXDGCommodity.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/14.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit

class FXDGCommodity: NSObject {
    var q_pic_url : String = ""
    var z_pic_url : String = ""
    //字典转模型
    init(dict : [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
