//
//  CFRefreshHeader.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/26.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

let pass150Offset:CGFloat = -150

class CFRefreshHeader: MJRefreshNormalHeader {

    var headerImageView:UIImageView!
    
    
    override func prepare() {
        
        super.prepare()
        
        //创建UIImageView
        headerImageView = UIImageView.init(image: UIImage(named: "home_header"))

        //将该UIImageView添加到当前header中
        
        self.addSubview(headerImageView)
        self.sendSubviewToBack(headerImageView)
        //根据拖拽的情况自动切换透明度
        self.isAutomaticallyChangeAlpha = true;
        self.lastUpdatedTimeLabel.isHidden = true;
        self.stateLabel.textColor = UIColor.gray;
        self.setTitle("下拉刷新", for: MJRefreshState.idle)
        //self.stateLabel.hidden = YES;
        
    }
    
    override func placeSubviews() {
        
        super.placeSubviews()
        
        headerImageView.mj_x = 0;
        headerImageView.mj_w = self.mj_w;
        headerImageView.mj_h = self.mj_w;
        headerImageView.mj_y = -headerImageView.mj_h + 54;
        
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        
        super.scrollViewContentOffsetDidChange(change)
        
        let point:CGPoint = change?["new"] as! CGPoint
        //加入字符串判断是确保滑动过程中只执行一次
        if point.y < pass150Offset && self.stateLabel.text != "松开抽大奖" {
            
            setTitle("松开抽大奖", for: MJRefreshState.pulling)
        }
        else if point.y < -54 && point.y > pass150Offset && self.stateLabel.text != "松开立即刷新"
        {
            setTitle("松开立即刷新", for: MJRefreshState.pulling)
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
