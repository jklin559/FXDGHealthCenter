//
//  FXDGUIButton.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/15.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit
extension UIButton {

    convenience init(title : String, bgColor : UIColor, fontSize : CGFloat) {
        self.init()
        
        setTitle(title, forState: .Normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}