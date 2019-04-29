//
//  CFClassificationCell.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/29.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFClassificationCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleStr: UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.mj_w, height: self.mj_w))
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        
        titleStr = UILabel.init(frame: CGRect(x: 15, y: self.mj_w + 15, width: self.mj_w - 30, height: 20))
        titleStr.font = UIFont.systemFont(ofSize: 14)
        titleStr.textColor = UIColor.black
        self.contentView.addSubview(titleStr)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
