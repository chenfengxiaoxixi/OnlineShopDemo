//
//  CFClassificationController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFClassificationController: CFBaseController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var leftTableView: UITableView!
    var leftData: Array<Any>!
    var rightCollectionView: UICollectionView!
    var selectIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle(title: "分类")
        leftData = ["推荐","男装","女装","电子","家具","美食","清洁","珠宝","办公","房产","儿童","鞋子","内衣","键盘","品牌","肉类","蔬菜","其他"]
        navigationView.backgroundColor = UIColor.white
        self.view.backgroundColor = BACKGROUND_VIEW_COLOR
        setTableViewAndCollectionView()
        // Do any additional setup after loading the view.
    }
    
    
    func setTableViewAndCollectionView() {
        
        leftTableView = UITableView.init(frame: CGRect(x: 0, y: STATUS_AND_NAV_BAR_HEIGHT, width: SCREEN_WIDTH/4, height: SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT - TABBAR_HEIGHT), style: .plain)
        leftTableView.separatorStyle = .none;
        leftTableView.backgroundColor = BACKGROUND_VIEW_COLOR;
        leftTableView.delegate = self;
        leftTableView.dataSource = self;
        self.view.addSubview(leftTableView)
        
        let layout = UICollectionViewFlowLayout.init()
        
        rightCollectionView = UICollectionView.init(frame: CGRect(x: leftTableView.mj_x+leftTableView.mj_w, y: STATUS_AND_NAV_BAR_HEIGHT, width: SCREEN_WIDTH/4*3, height: SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT - TABBAR_HEIGHT), collectionViewLayout: layout)
        rightCollectionView.backgroundColor = UIColor.clear
        rightCollectionView.delegate = self
        rightCollectionView.dataSource = self
        rightCollectionView.register(CFClassificationCell.classForCoder(), forCellWithReuseIdentifier: "CollectionCell")
        rightCollectionView.register(CFHomeCollectionHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        rightCollectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(rightCollectionView)
        
        //去掉顶部偏移
        if #available(iOS 11.0, *)
        {
            leftTableView.contentInsetAdjustmentBehavior = .never;
            rightCollectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func leftTableViewOffsetWith(indexPath:IndexPath) {
        
        //判断点击的cell是否靠近底部，或顶部，是则偏移指定位移
        let rect = leftTableView.rectForRow(at: indexPath)
        
        let total_offset = leftTableView.contentSize.height - leftTableView.mj_h//总偏移

        //44为cell高度,乘以3表示点击下面三个时偏移
        if rect.origin.y - leftTableView.mj_offsetY >= leftTableView.mj_h - 44 * 3 - 1 {
            
            let contentOffset_y = leftTableView.mj_offsetY + 44 * 3
            
            if total_offset - leftTableView.mj_offsetY < 44 * 3 {
                //判断ios 11直接设置偏移无效，我也没弄懂，必须延时才有效
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.leftTableView.setContentOffset(CGPoint(x: 0, y: total_offset), animated: true)
                }

            }
            else
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.leftTableView.setContentOffset(CGPoint(x: 0, y: contentOffset_y), animated: true)
                }
            }
        }
            //44为cell高度,乘以3表示点击上面三个时偏移
        else if rect.origin.y - leftTableView.mj_offsetY < 44 * 3
        {
            let contentOffset_y = leftTableView.mj_offsetY - 44 * 3
            
            if leftTableView.mj_offsetY < 44 * 3 {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.leftTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
            else
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.leftTableView.setContentOffset(CGPoint(x: 0, y: contentOffset_y), animated: true)
                }
            }
        }
    }
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CellIdentifier")
        }
        
        
        cell?.selectionStyle = .none;
        cell?.textLabel?.text = leftData[indexPath.row] as? String
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
        if selectIndex == indexPath.row {
            cell?.backgroundColor = UIColor.white;
        }
        else
        {
            cell?.backgroundColor = BACKGROUND_VIEW_COLOR;
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectIndex = indexPath.row;
        
        //用于判断lefttableView上下偏移
        leftTableViewOffsetWith(indexPath: indexPath)
        
        leftTableView.reloadData()
    }
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCellIden = "CollectionCell";

        let cell:CFClassificationCell! = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIden, for: indexPath) as? CFClassificationCell
        
        cell.titleStr.text = "测试商品";
        
        let imageName = String(format: "%@%d","commodity_",indexPath.row + 1)
        
        cell.imageView.image = UIImage(named: imageName);
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview : UICollectionReusableView!
        
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0{
            
            let headerView:CFHomeCollectionHeader! = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? CFHomeCollectionHeader
            reusableview = headerView;
        }
        
        return reusableview;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: rightCollectionView.mj_w, height: rightCollectionView.mj_w/16*7)
        }
        
        return CGSize(width: SCREEN_WIDTH, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count:CGFloat = 3
        return CGSize(width: (rightCollectionView.mj_w)/count, height: (rightCollectionView.mj_w)/count + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0);
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
