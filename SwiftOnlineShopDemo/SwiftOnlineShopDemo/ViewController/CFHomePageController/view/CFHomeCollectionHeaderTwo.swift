//
//  CFHomeCollectionHeaderTwo.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/25.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFHomeCollectionHeaderTwo: UICollectionReusableView,GYRollingNoticeViewDataSource, GYRollingNoticeViewDelegate {
    
    var arr1: Array<Any>!
    var noticeView : GYRollingNoticeView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        noticeView = GYRollingNoticeView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        noticeView.dataSource = self
        noticeView.delegate = self
        noticeView.backgroundColor = UIColor.lightGray
        self.addSubview(noticeView)

        arr1 = ["小米千元全面屏：抱歉，久等！625献上",
                "可怜狗狗被抛弃，苦苦等候主人半年",
                "三星中端新机改名，全面屏火力全开",
                "学会这些，这5种花不用去花店买了",
                "华为nova2S发布，剧透了荣耀10？"
                ];
        
        noticeView.register(GYNoticeViewCell.classForCoder(), forCellReuseIdentifier: "GYNoticeViewCell")
        noticeView.register(GYNoticeViewCell2.classForCoder(), forCellReuseIdentifier: "GYNoticeViewCell2")

        noticeView.reloadDataAndStartRoll()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfRows(for rollingView: GYRollingNoticeView!) -> Int {
        return arr1.count
    }
    
    func rollingNoticeView(_ rollingView: GYRollingNoticeView!, cellAt index: UInt) -> GYNoticeViewCell! {
        // 普通用法，只有一行label滚动显示文字
        // normal use, only one line label rolling
        if rollingView == noticeView {
            if (index < 3) {
                let cell = rollingView.dequeueReusableCell(withIdentifier: "GYNoticeViewCell")
                cell?.textLabel.text = String(format: "%@%@","第2种cell",arr1?[Int(index)] as! CVarArg)
                    cell?.contentView.backgroundColor = UIColor.white
                
                return cell;
            }else {
                
                
                let cell = rollingView.dequeueReusableCell(withIdentifier: "GYNoticeViewCell2")
                cell?.textLabel.text = String(format: "%@%@","第1种cell",arr1?[Int(index)] as! CVarArg)
                cell?.contentView.backgroundColor = UIColor.white
                return cell;
            }
        }
        
        return nil
    }
    
    func didClick(_ rollingView: GYRollingNoticeView!, for index: UInt) {
        
         print("点击的index: \(index)")

    }
}
