

import UIKit
import SDWebImage
class FXDGPhotoBrowserCell: UICollectionViewCell {
    // MARK:- 懒加载属性
    lazy var imageView : UIImageView = UIImageView()
    
    // MARK:- 定义的属性
    var commodity : FXDGCommodity? {
        didSet {
            guard let urlString = commodity?.q_pic_url else {
                return
            }
            var smallImage = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(urlString)
            if smallImage == nil {
                smallImage = UIImage(named: "empty_picture")
            }
            imageView.frame = calculateFrame(smallImage)
            guard let bigURLString = commodity?.z_pic_url else {
                return
            }
            let url = NSURL(string: bigURLString)
            imageView.sd_setImageWithURL(url, placeholderImage: smallImage, options: .RetryFailed) { (image, error, type, url) -> Void in
                self.imageView.frame = calculateFrame(image)
            }
        }
    }
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension FXDGPhotoBrowserCell {
    private func setupUI() {
        // 1.添加子控件
        contentView.addSubview(imageView)
    }
}