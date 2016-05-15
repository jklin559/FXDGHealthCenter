

import UIKit

class FXDGCommodityFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        
        let columns : CGFloat = 3
        let margin : CGFloat = 10
        let itemWidth = (UIScreen.mainScreen().bounds.width - margin * (columns + 1))/columns
        
        itemSize = CGSize(width: itemWidth, height: itemWidth)
        print(itemWidth)
        scrollDirection = .Vertical
        collectionView?.contentInset = UIEdgeInsets(top: margin + 64, left: margin, bottom: margin, right: margin)
    }
}
