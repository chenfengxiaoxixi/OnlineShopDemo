//
//  CFEditCollectionCell.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/29.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit




enum CFEditCollectionCellType {
    case none, deleting
}

enum CFEditCollectionCellStatus {
    case normal, editable
}

class CFEditCollectionCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    
    private var status: CFEditCollectionCellStatus!
    //闭包-类似于oc中的block
    var deleteButtonAction: ((UIButton) ->())?
    
    var origin: CGPoint!
    var isLeft: Bool!
    var deleteButton: UIButton!
    var pan: UIPanGestureRecognizer!
    var tap: UITapGestureRecognizer!
    let deleteBtnWidth: CGFloat = 70
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        status = .normal
        
        self.contentView.backgroundColor = UIColor.white;
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGesture(tap:)))
        tap.delegate = self;
        self.contentView.addGestureRecognizer(tap)
        
    }
    
    func configCollection(cellType:CFEditCollectionCellType) {
        
        if cellType == .deleting {
            
            pan = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureDidPan(panGesture:)))
            pan.delegate = self;
            self.contentView.addGestureRecognizer(pan)
            
            if deleteButton == nil {
                deleteButton = UIButton(type: .custom);
                deleteButton.frame = CGRect(x: self.mj_w - deleteBtnWidth, y: 0, width: deleteBtnWidth, height: self.mj_h)
                deleteButton.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
                deleteButton.setImage(UIImage(named: "delete"), for: .normal)
                deleteButton.backgroundColor = UIColor.red;
                self.addSubview(deleteButton)
                self.sendSubviewToBack(deleteButton)
            }
        }
        else if cellType == .none
        {

        }
    }
    
    @objc func deleteAction(sender:UIButton) {
        deleteButtonAction?(sender)
    }
    
    func hiddenButtonsWithAnimation() {
        
        if self.contentView.mj_x != 0 {
            UIView.animate(withDuration: 0.15, animations: {
                self.contentView.mj_x = 0
            }) { (Bool) in
                self.status = .normal
            }
        }
    }
    
    func showButtonsWithAnimation() {
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.mj_x = -self.deleteBtnWidth * 1;
        }) { (Bool) in
            self.status = .editable
        }
    }
    
    @objc func tapGesture(tap:UITapGestureRecognizer) {
        if status == .editable {
            hiddenButtonsWithAnimation()
        }
    }
    
    @objc func panGestureDidPan(panGesture:UIPanGestureRecognizer) {
        
        switch panGesture.state
        {
            case .began:
                origin = panGesture.translation(in: self)
            
            case .changed:
                let translation = panGesture.translation(in: self)
                isLeft = (translation.x < 0)
                print("panGesture.view.mj_x =\(translation.x)")
                if isLeft
                {
                    //多加了30的缓冲偏移量,因为translation.x并不一直是等差变化，滑动速度越快，中间变化量越大
                    if abs(translation.x) <= deleteBtnWidth*1 + 30 &&
                        status == .normal {
                        panGesture.view?.mj_x = translation.x;
                        
                    }
                        //左滑未松开然后又向左滑动
                    else if abs(translation.x) <= 30 &&
                        status == .editable
                    {
                        panGesture.view?.mj_x = -(deleteBtnWidth*1 - translation.x);
                    }
                    print("左");
                }
                else
                {
                    if abs(translation.x) <= deleteBtnWidth*1 + 30 &&
                        status == .editable {
                        panGesture.view?.mj_x = -(deleteBtnWidth*1 - translation.x);
                    }
                        //左滑滑未松开然后又向右滑动
                    else if abs(translation.x) <= 30 &&
                        status == .normal &&
                        panGesture.view?.mj_x != 0
                    {
                        panGesture.view?.mj_x = translation.x
                    }
                    print("右");
                }
            
            
            case .ended:
            
                print("end");
                
                if isLeft {
                    showButtonsWithAnimation()
                }
                else
                {
                    hiddenButtonsWithAnimation()
                }
            
            default:
                print("其他");
        }
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        //let currentCell:CFEditCollectionCell? = (self.superview as! UICollectionView).currentCell as? CFEditCollectionCell

        let currentCell:CFEditCollectionCell? = objc_getAssociatedObject((self.superview as! UICollectionView), &currentCellForKey) as? CFEditCollectionCell
        
        if gestureRecognizer == pan &&
            (gestureRecognizer.view?.isKind(of: UIView.classForCoder()))! {
            
            let translation = pan.translation(in: self)
            
            //关联对象
            objc_setAssociatedObject((self.superview as! UICollectionView), &currentCellForKey, self, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            //(self.superview as! UICollectionView).currentCell = self;

            //判断滑动
            if abs(translation.y) > abs(translation.x)//表示竖着滑动
            {
                //由于collectionView有边距，触摸到collectionView边距时，这个方法不会生效，所以滑动的时候在外部判断隐藏
                //[currentCell hiddenButtonsWithAnimation];//关闭当前左滑的cell
                return false;//禁止cell的竖向滑动，使其响应collectionview的上下滚动
            }
            
            if currentCell != self {
                currentCell?.hiddenButtonsWithAnimation()
            }
            
            //表示横着滑动
            return true;
        }
        else if gestureRecognizer == tap &&
            (gestureRecognizer.view?.isKind(of: UIView.classForCoder()))!
        {
            //判断如果当前没有滑动的cell，则关闭cell内部点击事件，响应外部didSelectItemAtIndexPath事件
            //x坐标不为0时，表示当前cell处于左滑状态
            if currentCell?.status == .editable {
                currentCell?.hiddenButtonsWithAnimation()//关闭当前左滑的cell
                
                return true;
            }
            else
            {
                return false;
            }
        }
        else if (gestureRecognizer.view?.isKind(of: UICollectionView.classForCoder()))!
        {
            return true
        }
        
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
