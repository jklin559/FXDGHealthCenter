

import UIKit
import SDWebImage

class FXDGPhotoBrowserController: UIViewController {
private let photoBrowserCellID = "photoBrowserCellID"
    var commodity : FXDGCommodity?
    var indexPathForSelectItem : NSIndexPath?
    var commodityArray :[FXDGCommodity]?
    
    // MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: FXDGPhotoBrowserFlowLayout())
    private lazy var closeBtn : UIButton = UIButton(title: "关 闭", bgColor: UIColor.darkGrayColor(), fontSize: 14.0)
    private lazy var saveBtn : UIButton = UIButton(title: "保 存", bgColor: UIColor.darkGrayColor(), fontSize: 14.0)

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //系统回调函数,可以用来增加cell 的间隔
    override func loadView() {
        super.loadView()
        view.frame.size.width += 15
        print(view.frame)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //按传入的indexpath跳转到对应的cell
        collectionView.scrollToItemAtIndexPath(indexPathForSelectItem!, atScrollPosition: .Left, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FXDGPhotoBrowserController {
    func setupUI(){
            // 1.添加子控件
            view.addSubview(collectionView)
            view.addSubview(closeBtn)
            view.addSubview(saveBtn)

            collectionView.frame = view.bounds
            let btnW : CGFloat = 90
            let btnH : CGFloat = 32
            let btnY = UIScreen.mainScreen().bounds.height - btnH - 20
            closeBtn.frame = CGRect(x: 20, y: btnY, width: btnW, height: btnH)
            let saveBtnX = UIScreen.mainScreen().bounds.width - btnW - 20
            saveBtn.frame = CGRect(x: saveBtnX, y: btnY, width: btnW, height: btnH)
        
            closeBtn.addTarget(self, action: "closeBtnClick", forControlEvents: .TouchUpInside)
            saveBtn.addTarget(self, action: "saveBtnClick", forControlEvents: .TouchUpInside)
        //注册cell
        collectionView.registerClass(FXDGPhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCellID)
            collectionView.dataSource = self
            collectionView.delegate = self

    }
}
//mark:-collection数据源/代理方法
extension FXDGPhotoBrowserController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allcommodityData.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCellID, forIndexPath: indexPath) as! FXDGPhotoBrowserCell
//         cell.shop = shops?[indexPath.item]
        cell.commodity = allcommodityData[indexPath.item]
        if allcommodityData.count == indexPath.item+1{
            downloadData(allcommodityData.count)
        }
        return cell
    }
    

}
//mark:-DismissDelegate
extension FXDGPhotoBrowserController : DismissDelegate {
    func dismissIndexPath() -> NSIndexPath {
        let cell = collectionView.visibleCells().first!
        return collectionView.indexPathForCell(cell)!
    }
    
    func dismissAnimationView() -> UIImageView {
        let imageView = UIImageView()
        let cell = collectionView.visibleCells().first as! FXDGPhotoBrowserCell
        imageView.image = cell.imageView.image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}


//mark:-数据下载
extension FXDGPhotoBrowserController {
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
            self.collectionView.reloadData()
        }
    }
}

// MARK:- 事件监听函数
extension FXDGPhotoBrowserController {
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func saveBtnClick() {
        let cell = collectionView.visibleCells().first as! FXDGPhotoBrowserCell
        let image = cell.imageView.image
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
}