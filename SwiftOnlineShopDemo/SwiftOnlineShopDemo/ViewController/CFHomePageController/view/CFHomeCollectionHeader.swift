//
//  CFHomeCollectionHeader.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/25.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFHomeCollectionHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let array = ["advertisement_1","advertisement_2","advertisement_3"];
        
        let cycleScrollView = SDCycleScrollView(frame: frame, imageNamesGroup: array)
        
        cycleScrollView?.backgroundColor = UIColor.white;
        cycleScrollView?.autoScrollTimeInterval = 3;
        cycleScrollView?.bannerImageViewContentMode = .scaleAspectFit;
        cycleScrollView?.currentPageDotColor = UIColor.red;
        self.addSubview(cycleScrollView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
