//
//  FXDGCommodityCell.swift
//  FXDGVitalSignsMonitor
//
//  Created by jklin on 16/5/14.
//  Copyright © 2016年 jklin. All rights reserved.
//

import UIKit
import SDWebImage
class FXDGCommodityCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var commodity :FXDGCommodity? {
        didSet{
            //先校验是否有值
            guard let URLStr = commodity?.q_pic_url else{
                print("数据错误")
                return
            }
            let commodityURL = NSURL(string: URLStr)
            //校验通过,对图片进行设置
            //            var contentMode =
            imageView.contentMode = .ScaleAspectFill
            imageView.sd_setImageWithURL(commodityURL!, placeholderImage: UIImage(named:"empty_picture"))
          
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }  
}
