//
//  CFShoppingCartHeaderView.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/29.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFShoppingCartHeaderView: UICollectionReusableView {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel.init(frame: CGRect(x: 0, y: 5, width: self.mj_w, height: 35))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "推荐商品";
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
