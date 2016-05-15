//
//  FXDGHeartRateCurveView.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/11.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit

enum refreshType : Int {
    case scanType = 0 //default
    case translationType = 1
}

class FXDGHeartRateCurveView: UIView {

    //数据0点
   private var middleY : CGFloat = 0
   private var timeX :CGFloat = 0
    //屏幕偏移量
    var offsetY :CGFloat = 0
    //最大数据量
    var maxDataCount : Int = 0

    //基础线宽
   private let baseSpace : CGFloat = 6
    //模式
    //曲线点数组
   private lazy var curvePoints = [CGPoint]()
    //当前点
   private var curPoint = CGPointMake(0, 0)
    //当前数据数
    private var curCount : Int = 0
    //刷新模式
    var screenRefreshType = refreshType.scanType{
        didSet{
            //修改刷新模式时清空
            curvePoints.removeAll()
            //重置
            curCount = 0
            timeX = 0
            setNeedsDisplay()
        }
    }
    //懒加载
    private lazy var curPointView : UIView = {
        let radius : CGFloat = 8
        let pointFrame = CGRectMake(-radius*0.5,-radius*0.5, radius, radius)
        let curPointView = UIView(frame: pointFrame)
        curPointView.layer.cornerRadius = 5
        curPointView.layer.masksToBounds = true
        curPointView.backgroundColor = UIColor.blueColor()
        
        return curPointView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        maxDataCount = Int(self.bounds.width)
    }
        //重绘
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawGrid()
        if curvePoints.count > 0 {
            drawCurve()
            drawCurPoint()
        }
    }
}
//mark:-网格/曲线绘制
extension FXDGHeartRateCurveView {
    //绘制网格,30/大格.6/小格
    private func drawGrid(){
        middleY = self.bounds.height * 0.5 + offsetY

    //绘制X方向网格
        //小格
        let context = UIGraphicsGetCurrentContext()
        let hight = self.bounds.height
        let width = self.bounds.width
        let gridSpace : CGFloat = baseSpace
        let gridBigSpace : CGFloat = gridSpace * 5
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        //设置线宽
        CGContextSetLineWidth(context, 0.2)
        for var x : CGFloat = 0 ; x < width ;x += gridSpace{
            CGContextMoveToPoint(context, x, 0)
            CGContextAddLineToPoint(context, x, hight)
            CGContextStrokePath(context)
        }
        //大格
        CGContextSetLineWidth(context, 0.8)
        for var x : CGFloat = 0 ; x < width ;x += gridBigSpace{
            CGContextMoveToPoint(context, x, 0)
            CGContextAddLineToPoint(context, x, hight)
            CGContextStrokePath(context)
        }
        //Y
        //小格
        CGContextSetLineWidth(context, 0.2)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        for var y : CGFloat = 0 ; y < hight ;y += gridSpace{
            CGContextMoveToPoint(context, 0, y)
            CGContextAddLineToPoint(context, width, y)
            CGContextStrokePath(context)
        }
        //大格
        CGContextSetLineWidth(context, 0.8)
        for var y : CGFloat = 0 ; y < hight ;y += gridBigSpace{
            CGContextMoveToPoint(context, 0, y)
            CGContextAddLineToPoint(context, width, y)
            CGContextStrokePath(context)
        }      
    }
    //绘制曲线
    private func drawCurve(){
        //按模式进行重绘
        switch screenRefreshType{
        case .scanType:
            refreshByScanType()
        case .translationType:
            self.refreshByTranslationType()
        }
    }
}

//mark:-API
extension FXDGHeartRateCurveView {
    func getHeartRateCurvedata(curvedata : CGFloat){
    //将数据转成点
        if timeX == CGFloat(maxDataCount){
            timeX = 0
        }

        let point = CGPointMake(timeX, curvedata + middleY)

        curCount++
        timeX++

        curPoint = point
        if screenRefreshType == .scanType && curCount > maxDataCount {
            let index = (curCount - 1) % maxDataCount
            curvePoints.removeAtIndex(index)
            curvePoints.insert(point, atIndex: index)
            
        }else{
            curvePoints.append(point)

        }
        //重绘

        setNeedsDisplay()
    }
    //扫描模式
    private func refreshByScanType(){
        self.addSubview(curPointView)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextSetLineJoin(context, .Round)
        
        for var i = 0 ; i < curvePoints.count;i++ {
            var point = curvePoints[i]
            var index = (curCount - 1) % maxDataCount
            if ((curCount - 1) / maxDataCount) == 0 {
            index = 0
            }
            if index == 0 {
            if i == 0 {
                CGContextMoveToPoint(context, point.x, point.y)
                CGContextAddLineToPoint(context, point.x, point.y)
            }else{
                CGContextAddLineToPoint(context, point.x, point.y)
            
            }
                
            }else{
                if i == 0 {
                CGContextMoveToPoint(context, point.x, point.y)
                }else{

                   CGContextAddLineToPoint(context, point.x, point.y)
                }
                if i == index {
                    CGContextAddLineToPoint(context, point.x, point.y)
                    CGContextStrokePath(context)
                    if index+1 == maxDataCount{
                    return
                    }
                    i++
                    point = curvePoints[i]
                CGContextMoveToPoint(context, point.x, point.y)
                }
            }
            


            
        }
        CGContextStrokePath(context)
    }
    
    //位移模式
    func refreshByTranslationType(){
        curPointView.removeFromSuperview()
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextSetLineJoin(context, .Round)
        for var i = 0 ; i < curvePoints.count;i++ {
            let point = curvePoints[i]

                if i == 0 {
                    CGContextMoveToPoint(context, CGFloat(curvePoints.count - i - 1), point.y)
                    CGContextAddLineToPoint(context,CGFloat(curvePoints.count - i - 1), point.y)
                }else{
                    CGContextAddLineToPoint(context,CGFloat(curvePoints.count - i - 1), point.y)
                    
                }
         
        }
                CGContextStrokePath(context)
        if curvePoints.count >  maxDataCount + 100{
            let removeRang = Range(start: 0, end: 100)
            print(curvePoints.count)
        curvePoints.removeRange(removeRang)
        }

    }
    //画出当前点
    func drawCurPoint(){
        curPointView.transform = CGAffineTransformMakeTranslation(curPoint.x,curPoint.y)
    }
}








