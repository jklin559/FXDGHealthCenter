//
//  FXDGHeartRateCurveVC.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/11.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit

class FXDGHeartRateCurveVC: UIViewController {
    var curveData : [String]?
    var dataIndex = 0
    var getCurveDataTimer : NSTimer?
    var collectionTime : NSTimeInterval = 0.04/6

    @IBOutlet weak var refreshTypeBtn: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var heartRateCurveView: FXDGHeartRateCurveView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        //强制横屏
        if UIDevice.currentDevice().respondsToSelector("setOrientation:"){
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
        }
        //初始化设置
        setupNavigationBar()
        //读取数据,绘图
        getCurveData()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//mark:-setup方法
extension FXDGHeartRateCurveVC {
    
    private func setupNavigationBar(){
    let settingButton = UIButton(type: .Custom)
        settingButton.setImage(UIImage(named: "icon_settings"), forState: .Normal)
        settingButton.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    }
}
//mark:-关闭此界面下的竖屏模式
extension FXDGHeartRateCurveVC {
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .LandscapeRight
    }
}
//mark:-点击事件
extension FXDGHeartRateCurveVC {

    @IBAction func startBtnClick(sender: UIButton) {
        startButton.selected = !startButton.selected
        if startButton.selected == true {
        getCurveDataTimer!.invalidate()
        }else{
        getCurveDataTimer!.invalidate()
        getCurveDataTimer = NSTimer(timeInterval: collectionTime, target: self, selector: "updata", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(getCurveDataTimer!, forMode: NSDefaultRunLoopMode)
        }
    }
    @IBAction func refreshTypeBtnClick(sender: UIButton) {
        refreshTypeBtn.selected = !refreshTypeBtn.selected        
        heartRateCurveView.screenRefreshType = refreshTypeBtn.selected ? refreshType.translationType :refreshType.scanType
    }
}
//mark:-其他
extension FXDGHeartRateCurveVC {

    //获取数据
    private func getCurveData(){
        //伪数据 componentsSeparatedByString
        let curveDataStr = try? NSString(contentsOfFile: NSBundle.mainBundle().pathForResource("data", ofType: "txt")!, encoding:NSUTF8StringEncoding)
        curveData = curveDataStr?.componentsSeparatedByString(",")
        //模拟仪器0.2s传输一次数据
        getCurveDataTimer = NSTimer(timeInterval: collectionTime, target: self, selector: "updata", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(getCurveDataTimer!, forMode: NSDefaultRunLoopMode)
    }
    func updata(){
        if dataIndex > 960 {
            dataIndex = 0
        }
        let data = (self.curveData![dataIndex] as NSString).integerValue
        let dataF = CGFloat(2048 - data) * 0.5
        self.heartRateCurveView.getHeartRateCurvedata(dataF)
        dataIndex++
        
    }

}