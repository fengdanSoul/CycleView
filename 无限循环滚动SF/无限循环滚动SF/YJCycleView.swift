//
//  YJCycleView.swift
//  YJDY
//
//  Created by yj on 2016/11/28.
//  Copyright © 2016年 99baozi. All rights reserved.
//

import UIKit
import Kingfisher


private let kCycleViewCell = "kCycleViewCell"


class YJCycleView: UIView {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer : Timer?
    var isURL : Bool?
    
    
    var dataArray = [String]() {
        didSet {
            isURL = dataArray[0].hasPrefix("http")
            pageControl.numberOfPages = dataArray.count
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 注册cell
        collectionView.register(UINib(nibName: "YJCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleViewCell)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        
        
        addTimer()
    }
}
//MARK - 创建
extension YJCycleView {
    class func cycleView() -> YJCycleView {
        return Bundle.main.loadNibNamed("YJCycleView", owner: nil, options: nil)?.first as! YJCycleView
    }
}

//MARK - 定时器
extension YJCycleView {
    
    /// 添加定时器
    func addTimer()  {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        
    }
    /// 移除定时器
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 自动滚动-->下一页
    func nextPage() {
        let visibalePath = collectionView.indexPathsForVisibleItems.last
        
        var visibaleItem = visibalePath?.item
        
        if visibaleItem! % dataArray.count == 0 {
            collectionView .scrollToItem(at: NSIndexPath(item: visibaleItem!, section: 0) as IndexPath, at: .left, animated: false)
        }
        
        visibaleItem = visibaleItem! + 1
        
        collectionView.scrollToItem(at: NSIndexPath(item: visibaleItem!, section: 0) as IndexPath, at: .left, animated: true)
        
    }
}

//MARK - 数据源方法
extension YJCycleView : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count * 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleViewCell, for: indexPath) as! YJCycleCell
        
        let itemStr = dataArray[indexPath.item % dataArray.count]
        
        cell.titleLB.text = itemStr
        
        
        if isURL! { // 网络图片
            
            if let iconURL = URL(string: itemStr) {
                cell.imageView.kf.setImage(with: iconURL)
            }
            
        } else { // 本地图片
            cell.imageView.image = UIImage(named: itemStr)
        }
        
        
        if indexPath.item == 0 {
            collectionView.scrollToItem(at: NSIndexPath(item: dataArray.count, section: 0) as IndexPath, at: .left, animated: false)
        }
        

        return cell
        
    }
    
}

//MARK - 代理
extension YJCycleView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let visiblePath = collectionView.indexPathsForVisibleItems.last
        
        if let indexPath = visiblePath {
            pageControl.currentPage = indexPath.item % dataArray.count
        } else {
            pageControl.currentPage = 0
        }
    }

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()

        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }

}

extension YJCycleView : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
}






