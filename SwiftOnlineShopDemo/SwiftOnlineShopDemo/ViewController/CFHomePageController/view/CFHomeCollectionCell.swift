//
//  CFHomeCollectionCell.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/25.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFHomeCollectionCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleStr: UILabel!
    //闭包-类似于oc中的block
    var addToShoppingCar: ((UIImageView) ->())?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor.white
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.mj_w, height: self.mj_w))
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        
        titleStr = UILabel.init(frame: CGRect(x: 15, y: self.mj_w + 15, width: self.mj_w - 30, height: 20))
        titleStr.font = UIFont.systemFont(ofSize: 14)
        titleStr.textColor = UIColor.black
        self.contentView.addSubview(titleStr)
        
        let addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: 15, y: titleStr.mj_y + titleStr.mj_h + 10, width: 80, height: 20)
        addButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addButton.setTitle("加入购物车", for: .normal)
        addButton.setTitleColor(UIColor.red, for: .normal)
        addButton.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        self.contentView.addSubview(addButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addAction(sender:UIButton) {
        
        addToShoppingCar?(imageView)
    }
    
}
