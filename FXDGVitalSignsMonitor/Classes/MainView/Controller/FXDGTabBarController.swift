//
//  FXDGTabBarController.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/13.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit

class FXDGTabBarController: UITabBarController {
    lazy var tabBarItems = [UITabBarItem]()

    
      override class func initialize(){
    let item = UITabBarItem.appearanceWhenContainedInInstancesOfClasses([FXDGTabBarController.self])
    var attr = [String : AnyObject]()
    attr[NSForegroundColorAttributeName] = UIColor.blackColor()
//    item.setTitleTextAttributes(attr, forState: .Normal)
    item.setTitleTextAttributes(attr, forState: .Selected)
    var attrnor = [String : AnyObject]()
    attrnor[NSFontAttributeName] = UIFont.boldSystemFontOfSize(13)
    
        item.setTitleTextAttributes(attrnor, forState:.Normal)
    }    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllChildViewController()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension FXDGTabBarController {
    private func addAllChildViewController(){
        //仪器连接界面
        let mainVC = UIStoryboard(name: "FXDGMainViewController", bundle: nil).instantiateInitialViewController()
        self.addChildViewController(mainVC!, title: "连接设备", image: UIImage(named:"tabBar_essence_icon"), selectImage: UIImage(named: "tabBar_essence_click_icon"))
        let mainVC1 = UIStoryboard(name: "FXDGMainViewController", bundle: nil).instantiateInitialViewController()
        self.addChildViewController(mainVC1!, title: "联系客服", image: UIImage(named:"tabBar_friendTrends_icon"), selectImage: UIImage(named: "tabBar_friendTrends_click_icon"))
        let mainVC2 = UIStoryboard(name: "FXDGMainViewController", bundle: nil).instantiateInitialViewController()
        self.addChildViewController(mainVC2!, title: "个人中心", image: UIImage(named:"tabBar_me_icon"), selectImage: UIImage(named: "tabBar_me_click_icon"))
        let commodityVC = UIStoryboard(name: "FXDGCommodityVC", bundle: nil).instantiateInitialViewController()
        self.addChildViewController(commodityVC!, title: "购物中心", image: UIImage(named:"tabBar_new_icon"), selectImage: UIImage(named: "tabBar_new_click_icon"))
        

        
    }
    
    func addChildViewController(childController: UIViewController, title : String ,image : UIImage? ,selectImage : UIImage?) {
        let navVC = FXDGNavigationController(rootViewController: childController)
        addChildViewController(navVC)
        navVC.title = title
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        navVC.tabBarItem.selectedImage = selectImage
        tabBarItems.append(navVC.tabBarItem)
    }
}



