
import UIKit

class FXDGPhotoBrowserFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        //流水布局的属性
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        itemSize = collectionView!.bounds.size
        
        //调用者的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}
