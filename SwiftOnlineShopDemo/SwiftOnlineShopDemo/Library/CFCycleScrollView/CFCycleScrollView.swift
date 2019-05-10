//
//  CFCycleScrollView.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/28.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

@objc protocol CFCycleScrollViewDataSource {
    
    func getImagesWithArray() -> Array<Any>
}

class CFCycleScrollView: UIView,UIScrollViewDelegate {

    weak open var dataSource: CFCycleScrollViewDataSource?{
        //外部设置完之后调用这个方法
        didSet { self.setDataSource() }
    }
    var bgScrollView: UIScrollView!
    var currentScrollView: UIScrollView!
    var currentIndex: Int!
    var total: Int!
    var endOffsetX: CGFloat!
    var pageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //底层scrollView
        bgScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        bgScrollView.isPagingEnabled = true;
        bgScrollView.delegate = self;
        bgScrollView.showsHorizontalScrollIndicator = false;
        self.addSubview(bgScrollView);
        endOffsetX = 0;
        currentIndex = 0;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource()
    {
        
        let array = dataSource?.getImagesWithArray()
        
        bgScrollView.contentSize = CGSize(width: CGFloat(array?.count ?? 0) * frame.size.width, height: frame.size.height)

        total = array?.count;
        
        self.showPageCount()
        
        for i in 0..<total {
            let image = array?[i]
            
            if image is String
            {
                //嵌套的scrollView，用来包住每个imageview；实现的遮盖效果，实际是操作的imageview在childScrollView上的偏移
                let childScrollView = UIScrollView.init(frame: CGRect(x: frame.size.width * CGFloat(i), y: 0, width: frame.size.width, height: frame.size.height))
                childScrollView.tag = 100 + i;
                bgScrollView.addSubview(childScrollView)
                
                let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
                imageView.contentMode = .scaleAspectFit;
                imageView.image = UIImage(named: image as! String);
                childScrollView.addSubview(imageView);
                
                if (i == 0) {
                    currentScrollView = childScrollView;
                }
                
            }
            else
            {
                
            }
        }
        
    }
    
    func showPageCount() {
        
        let view = UIView.init(frame: CGRect(x: frame.size.width/2 - 30, y: frame.size.height - 60, width: 60, height: 25))
        view.backgroundColor = UIColor.clear;
        self.addSubview(view)
        
        let grayView = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        grayView.backgroundColor = UIColor.black;
        grayView.alpha = 0.4;
        grayView.layer.cornerRadius = 12.5;
        view.addSubview(grayView)
        
        pageLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        pageLabel.textColor = UIColor.white
        pageLabel.font = UIFont.systemFont(ofSize: 12);
        pageLabel.textAlignment = .center;
        pageLabel.text = String(format: "%d/%d", currentIndex+1,total)
        view.addSubview(pageLabel)
        
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let contentOffset = targetContentOffset.pointee;
        
        currentIndex = Int(contentOffset.x/self.mj_h);
        
        endOffsetX = contentOffset.x;
        
        pageLabel.text = String(format: "%d/%d", currentIndex+1,total)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //计算childScrollView的起始偏移，使每个childScrollView始终在0~self.mj_w范围偏移
        var childScrollViewOffset = scrollView.contentOffset.x - frame.size.width * CGFloat(currentIndex);
        //底部scrollView总偏移
        let scrollViewOffset = scrollView.contentOffset.x;
        //向左滑动
        if (scrollViewOffset >= endOffsetX) {
            print("向左滑动");
            //向左滑动时，执行减速的视图为当前childScrollView
            currentScrollView = bgScrollView.viewWithTag(100 + currentIndex) as? UIScrollView
            
            if scrollView == bgScrollView{
                //因为currentScrollView是放在self上的，self向左速度为1，实际上currentScrollView的速度也是1，此处认为设置currentScrollView往反方向走1/2的速度，最后就形成了视觉差！
                currentScrollView.contentOffset = CGPoint(x: -childScrollViewOffset/2, y: currentScrollView.contentOffset.y)
            }
        }
        else
        {
            print("向右滑动");
            if scrollViewOffset < 0 {
                return;
            }
            
            childScrollViewOffset = scrollView.contentOffset.x - self.mj_w * CGFloat(currentIndex - 1);
            
            //向右滑动时，执行减速的视图为上一个childScrollView
            currentScrollView = bgScrollView.viewWithTag(100 + currentIndex - 1) as? UIScrollView
            
            if scrollView == bgScrollView {
                //因为currentScrollView是放在self上的，self向左速度为1，实际上currentScrollView的速度也是1，此处认为设置currentScrollView往反方向走1/2的速度，最后就形成了视觉差！
                currentScrollView.contentOffset = CGPoint(x: -childScrollViewOffset/2, y: currentScrollView.contentOffset.y)
            }
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
