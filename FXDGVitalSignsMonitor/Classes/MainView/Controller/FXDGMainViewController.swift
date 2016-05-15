//
//  FXDGMainViewController.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/10.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit

class FXDGMainViewController: UIViewController {
    var collectionView : UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
//        setupView()

    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        super.viewWillAppear(animated)
        //竖屏
        if UIDevice.currentDevice().respondsToSelector("setOrientation:"){
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//mark:-关闭此界面下的竖屏模式
extension FXDGMainViewController {
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
}
//mark:-点击事件
extension FXDGMainViewController {

    @IBAction func addMoveView(sender: AnyObject) {
        
    }

}
//mark:-其他
extension FXDGMainViewController {
    private func setupBackground(){
    let backGround = UIImageView(image: UIImage(named:"background_board-568"))
        backGround.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        view.insertSubview(backGround, atIndex: 0)
    }

    
}

extension FXDGMainViewController : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

}



