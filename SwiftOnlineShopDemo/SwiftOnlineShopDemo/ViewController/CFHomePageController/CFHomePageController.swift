//
//  CFHomePageController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit
//@_exported import Moya
import Moya

class CFHomePageController: CFBaseController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var searchBtn: UIButton!
    var searchImageView: UIImageView!
    var headerOffsetY: CGFloat!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BACKGROUND_VIEW_COLOR
        
        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    open func setUI() {
        
        searchBtn = UIButton(type: .custom)
        searchBtn.frame = CGRect(x: 20, y: STATUSBAR_HEIGHT + 5, width: SCREEN_WIDTH - 40, height: 30)
        searchBtn.backgroundColor = UIColor.white
        searchBtn.setTitle("搜索你想要的商品名称", for: .normal)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        searchBtn.setTitleColor(UIColor.gray, for: .normal)
        searchBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
        searchBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: -30)
        searchBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        searchBtn .addTarget(self, action: #selector(homePageSearchButtonClick), for: .touchUpInside)
        searchBtn.layer.cornerRadius = 15;
        navigationView.addSubview(searchBtn)
        
        searchImageView = UIImageView.init(frame: CGRect(x: 20, y: 5, width: 20, height: 21))
        searchImageView.image = UIImage(named:"home_search")
        searchBtn.addSubview(searchImageView)
        
        let layout = UICollectionViewFlowLayout.init()
        
        collectionView = UICollectionView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - TABBAR_HEIGHT), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CFHomeCollectionCell.classForCoder(), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.register(CFHomeCollectionHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(CFHomeCollectionHeaderTwo.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header2")
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        
        //去掉顶部偏移
        if #available(iOS 11.0, *){
            collectionView.contentInsetAdjustmentBehavior = .never
        }

        
        collectionView.mj_header = CFRefreshHeader(refreshingBlock: {
            
            if self.headerOffsetY < pass150Offset
            {
                self.collectionView.mj_header.endRefreshing()
                
                let actionSheetController = UIAlertController(title: "谢谢惠顾", message: "", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "确定", style: .default, handler: { (action:UIAlertAction) in
                    
                })
                
                actionSheetController.addAction(confirm)
                self.present(actionSheetController, animated: true, completion: nil)
            }
            else
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.collectionView.mj_header.endRefreshing()
                }
                
            }
            
        })
        
    }
    
    
    @objc func homePageSearchButtonClick()
    {
        
        
    }
    
    
    // MARK: - UICollectionView Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCellIden = "CollectionCell";
        // as向上转型，as！（返回不能为空）和as？（返回可以为空）向下转型，这里可以理解为collectionView.dequeueReusableCell这个方法返回的是UICollectionViewCell，然后使用as？向下转型为子类CFHomeCollectionCell
        let cell:CFHomeCollectionCell! = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIden, for: indexPath) as? CFHomeCollectionCell
        
        cell.titleStr.text = "测试商品";
        
        let imageName = String(format: "%@%d","commodity_",indexPath.row + 1)

        cell.imageView.image = UIImage(named: imageName);
        
        //类似oc的block调用，这里是swift的闭包
        cell.addToShoppingCar = {(imageView:UIImageView) in
            
            let wCell = collectionView.cellForItem(at: indexPath)
            var rect = wCell?.frame
            
            // 获取当前cell 相对于self.view 当前的坐标
            rect!.origin.y = (rect?.origin.y)! - collectionView.contentOffset.y

            var imageViewRect = imageView.frame
            imageViewRect.origin.x = (rect?.origin.x)!
            imageViewRect.origin.y = (rect?.origin.y)! + imageViewRect.origin.y
            
            PurchaseCarAnimationTool.share()?.startAnimationandView(imageView, rect: imageViewRect, finisnPoint: CGPoint(x: SCREEN_WIDTH / 4 * 2.5, y: SCREEN_HEIGHT - TABBAR_HEIGHT), finish: { (finish:Bool) in
    
               if (self.tabBarController as AnyObject).isKind(of:CFTabBarController.classForCoder())
               {
                
                PurchaseCarAnimationTool.shakeAnimation(self.tabBarController!.tabBar.subviews[3]);
                
               }

            })
        
        };
        
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview : UICollectionReusableView!
        
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0{
            
            let headerView:CFHomeCollectionHeader! = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? CFHomeCollectionHeader
            reusableview = headerView;
        }
        else if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 1{
            
            let headerView:CFHomeCollectionHeaderTwo! = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header2", for: indexPath) as? CFHomeCollectionHeaderTwo
       
            reusableview = headerView;
        }
        
        return reusableview;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH/16*7)
        }
        
        return CGSize(width: SCREEN_WIDTH, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count:CGFloat = 2
        return CGSize(width: (SCREEN_WIDTH - 25)/count, height: (SCREEN_WIDTH - 25)/count + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = CFDetailInfoController();
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - ScllowView Method
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView.mj_offsetY < 0 {
            headerOffsetY = scrollView.mj_offsetY;
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.mj_offsetY < 0
        {
            if navigationView.alpha == 1 {
                UIView.animate(withDuration: 0.1) {
                    self.navigationView.alpha = 0
                }
            }
        }
        else
        {
            if navigationView.alpha == 0 {
                UIView.animate(withDuration: 0.1) {
                    self.navigationView.alpha = 1
                }
            }
            
            if scrollView.mj_offsetY > 0 && scrollView.mj_offsetY < 40 {
                
                navigationBgView.alpha = 1 * (scrollView.mj_offsetY / 40);
                //由于只有白色导航背景是渐变，所以做个判断，以免一直执行
                if (searchBtn.currentTitleColor != UIColor.lightGray) {
                    navigationBgView.backgroundColor = UIColor.white;
                    searchImageView.image = UIImage(named: "home_search");
                    searchBtn.backgroundColor = UIColor.white;
                    searchBtn.setTitleColor(UIColor.gray, for: .normal);
                }
            }
            else if scrollView.mj_offsetY <= 0
            {
                navigationBgView.alpha = 0;
            }
            else if scrollView.mj_offsetY > 40
            {
                if (navigationBgView.alpha != 1) {
                    navigationBgView.alpha = 1;
                    searchBtn.backgroundColor = VERY_LIGHT_COLOR;
                    searchBtn.setTitleColor(UIColor.white, for: .normal)
                    searchImageView.image = UIImage(named: "home_search_white");
                }
            }
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
