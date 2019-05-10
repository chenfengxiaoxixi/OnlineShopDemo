//
//  CFShoppingCartController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

var currentCellForKey = "currentCell"

//extension UICollectionView{
//
//    var currentCell: UICollectionViewCell?{
//        set {
//            objc_setAssociatedObject(self, &keyName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//
//        get {
//            if let rs = objc_getAssociatedObject(self, &keyName) as? UICollectionViewCell {
//                return rs
//            }
//            return nil
//        }
//    }
//
//}

class CFShoppingCartController: CFBaseController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.backgroundColor = UIColor.white
        self.view.backgroundColor = BACKGROUND_VIEW_COLOR
        self.setTitle(title: "购物车")
        setCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func setCollectionView() {
        
        let layout = UICollectionViewFlowLayout.init()
        
        collectionView = UICollectionView.init(frame: CGRect(x:0, y:STATUS_AND_NAV_BAR_HEIGHT, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - TABBAR_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CFShoppingCartCell1.classForCoder(), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.register(CFShoppingCartCell2.classForCoder(), forCellWithReuseIdentifier: "CollectionCell2")
        collectionView.register(CFShoppingCartHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        
        //去掉顶部偏移
        if #available(iOS 11.0, *)
        {
            collectionView.contentInsetAdjustmentBehavior = .never;
        }
        
    }

    // MARK: - UICollectionView Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let collectionCellIden = "CollectionCell";

            let cell:CFShoppingCartCell1! = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIden, for: indexPath) as? CFShoppingCartCell1
            
            cell.configCollection(cellType: .deleting)
            
            cell.titleStr.text = "测试商品"
            
            let imageName = String(format: "%@%d","commodity_",indexPath.row + 1)
            
            cell.imageView.image = UIImage(named: imageName)
            
            cell.deleteButtonAction = {(button:UIButton) in
                print("删除操作")
            }
            
            return cell
        }
        else
        {
            let collectionCellIden = "CollectionCell2";
            
            let cell:CFShoppingCartCell2! = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIden, for: indexPath) as? CFShoppingCartCell2
            
            cell.configCollection(cellType: .none)
            
            cell.titleStr.text = "测试商品"
            
            let imageName = String(format: "%@%d","commodity_",indexPath.row + 1)
            
            cell.imageView.image = UIImage(named: imageName)
            
            cell.deleteButtonAction = {(button:UIButton) in
                print("删除操作")
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview : UICollectionReusableView?
        
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 1{
            
            let headerView:CFShoppingCartHeaderView! = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? CFShoppingCartHeaderView
            
            reusableview = headerView;
        }
        
        return reusableview ?? UIView() as! UICollectionReusableView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: 0, height: 0)
        }
        
        return CGSize(width: SCREEN_WIDTH, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.mj_w - 10, height: 80)
        }
        
        let count:CGFloat = 2
        return CGSize(width: (SCREEN_WIDTH - 25)/count, height: (SCREEN_WIDTH - 25)/count + 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10);
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("开始拖动");
        collectionView.visibleCells.forEach { (cell) in
            (cell as! CFEditCollectionCell).hiddenButtonsWithAnimation()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
