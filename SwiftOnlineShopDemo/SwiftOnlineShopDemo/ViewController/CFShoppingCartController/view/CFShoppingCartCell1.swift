//
//  CFShoppingCartCell1.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/29.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFShoppingCartCell1: CFEditCollectionCell {
    
    var imageView: UIImageView!
    var titleStr: UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor.white
        
        imageView = UIImageView.init(frame: CGRect(x: 15, y: 10, width: 60, height: 60))
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        
        titleStr = UILabel.init(frame: CGRect(x: imageView.mj_x + imageView.mj_w + 15, y: 15, width: 150, height: 20))
        titleStr.font = UIFont.systemFont(ofSize: 14)
        titleStr.textColor = UIColor.black
        self.contentView.addSubview(titleStr)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
