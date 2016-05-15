

import UIKit

private let reuseIdentifier = "commodityCell"

class FXDGCommodityVC: UICollectionViewController {
    var offset = 0
    private lazy var transformAnimation = FXDGTransformAnimation()
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadData(offset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//mark:-数据源/代理方法

extension FXDGCommodityVC {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allcommodityData.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FXDGCommodityCell
        let commodity = allcommodityData[indexPath.item]
        cell.commodity = commodity
        
        if allcommodityData.count == indexPath.item+1{
            downloadData(allcommodityData.count)
        }
        
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //点击跳转到大图浏览界面
         let photoBrowserController = FXDGPhotoBrowserController()
        photoBrowserController.indexPathForSelectItem = indexPath
//        // 自定义动画转场
        photoBrowserController.modalPresentationStyle = .Custom

        photoBrowserController.transitioningDelegate = transformAnimation
        transformAnimation.indexPath = indexPath
        transformAnimation.presentDelegate = self
        transformAnimation.dismissDelegate = photoBrowserController
        
        presentViewController(photoBrowserController, animated: true) { () -> Void in
            
        }
    }
}
// MARK:- PresentDelegate
extension FXDGCommodityVC : PresentDelegate {
    func presentStartRect(indexPath: NSIndexPath) -> CGRect {
        let cell = (collectionView?.cellForItemAtIndexPath(indexPath))!
        let startFrame = collectionView!.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return startFrame
    }
    
    func presentEndRect(indexPath: NSIndexPath) -> CGRect {
        let cell = (collectionView?.cellForItemAtIndexPath(indexPath) as? FXDGCommodityCell)!
        let image = cell.imageView.image
        return calculateFrame(image!)
    }
    
    func presentAnimationView(indexPath: NSIndexPath) -> UIImageView {
        let imageView = UIImageView()
        let cell = (collectionView?.cellForItemAtIndexPath(indexPath))! as! FXDGCommodityCell
        let image = cell.imageView.image
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    func presentAnimationViewBackgroundImage()->UIImage{
        UIGraphicsBeginImageContext(view.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        self.view.layer.renderInContext(context!)
        let backGroundImage =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    return backGroundImage
    }
}


//mark:-数据下载
extension FXDGCommodityVC {
    //利用自己在AFNetworking上的封装进行下载
    private func downloadData(offset : Int){
        let downloadTool = FXDGDownloadTool.shareDownloadToll
        downloadTool.downloadCommodityDate(offset) { (result, error) -> () in
            //校验错误
            if error != nil{
                print(error)
                return
            }
            
            guard let resultArray = result else{
                print("数据错误")
                return
            }
            //遍历赋值
            for commodityDict in resultArray{
                let commodity = FXDGCommodity(dict: commodityDict)
                allcommodityData.append(commodity)
            }
            print("数据下载完成")
            self.collectionView?.reloadData()
        }
    }
}


