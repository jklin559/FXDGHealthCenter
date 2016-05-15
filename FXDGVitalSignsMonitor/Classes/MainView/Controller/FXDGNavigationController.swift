//
//  FXDGNavigationController.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/10.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit

class FXDGNavigationController: UINavigationController {
//mark:-自定义标题大小和背景
    override class func initialize() {
        //获取当前的navigationBar
        let navigationBar = UINavigationBar.appearanceWhenContainedInInstancesOfClasses([FXDGNavigationController.self])
        UINavigationBar.appearance()
        var attributeDict = [String : AnyObject]()
        attributeDict[NSFontAttributeName] = UIFont.boldSystemFontOfSize(18)
        navigationBar.titleTextAttributes = attributeDict
        navigationBar.setBackgroundImage(UIImage(named: "navigationbarBackgroundWhite"), forBarMetrics: .Default)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       //全屏滑动功能
        // 滑动功能
        let pan = UIPanGestureRecognizer(target: self.interactivePopGestureRecognizer?.delegate, action: "handleNavigationTransition:")
        self.view.addGestureRecognizer(pan)
        pan.delegate = self
        self.interactivePopGestureRecognizer?.enabled = false

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//mark:-UIGestureRecognizerDelegate
extension FXDGNavigationController : UIGestureRecognizerDelegate{
    //根控制器不触发手势
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return self.childViewControllers.count > 1
    }
    override func pushViewController(viewController: UIViewController, animated: Bool) {

        if self.childViewControllers.count > 0{
            viewController.hidesBottomBarWhenPushed = true
        let backButton = UIButton(type: .Custom)
            
            backButton.setTitle("返回", forState: .Normal)
            backButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            backButton.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            
            backButton.setImage(UIImage(named: "navigationButtonReturn"), forState: .Normal)
            backButton.setImage(UIImage(named: "navigationButtonReturnClick"), forState: .Highlighted)
            
            backButton.addTarget(self, action: "backBtnClick", forControlEvents: .TouchUpInside)
            backButton.sizeToFit()
            backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)


        }
        super.pushViewController(viewController, animated: animated)
    }
}
//mark:-点击事件
extension FXDGNavigationController {
    @objc private func backBtnClick(){
    self.popViewControllerAnimated(true)
    }
}
