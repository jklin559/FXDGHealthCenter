//
//  FXDGCommonData.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/14.
//  Copyright © 2016年 jklin. All rights reserved.
//


import UIKit

var allcommodityData : [FXDGCommodity] = [FXDGCommodity]()

func calculateFrame(image : UIImage) -> CGRect {
    let x : CGFloat = 0
    let width : CGFloat = UIScreen.mainScreen().bounds.width
    let height = width / image.size.width * image.size.height
    let y = (UIScreen.mainScreen().bounds.height - height) * 0.5
    
    return CGRect(x: x, y: y, width: width, height: height)
}