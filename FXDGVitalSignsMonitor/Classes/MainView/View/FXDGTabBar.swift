//
//  FXDGTabBar.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/13.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit

class FXDGTabBar: UITabBar {

    var tabBarItems  = [UITabBarItem]() {
        didSet{
            var btnTag = 0
            for btn in tabBarItems{
            let newBtn = UIButton(type: .Custom)
                newBtn.setImage(btn.image, forState: .Normal)
                newBtn.setImage(btn.selectedImage, forState: .Selected)
                newBtn.tag = btnTag

                btnTag++
                addSubview(newBtn)
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        let btnCount = self.subviews.count
//        let btnWidth = self.frame.size.width / CGFloat(btnCount)
//        let btnHight = self.frame.size.height
//        for i in 0..<btnCount{
//        let btn = self.subviews[i] as! UIButton
//          btn.frame = CGRectMake(btnWidth * CGFloat(i), 0, btnWidth, btnHight)
//            print(btn.frame)
//        }
        
    }
}
