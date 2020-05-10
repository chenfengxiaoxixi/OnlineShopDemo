//
//  CFPersonalCenterController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFPersonalCenterController: CFBaseController,UITableViewDelegate,UITableViewDataSource {

    var tableView: UITableView!
    var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setTitle(title: "我的")
        self.view.backgroundColor = BACKGROUND_VIEW_COLOR
        navigationView.backgroundColor = .white
        setUI()
    }
    
    func setUI() {
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: STATUS_AND_NAV_BAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT - TABBAR_HEIGHT))
        tableView.backgroundColor = .white
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)//使table上面空出200空白
        self.view.addSubview(tableView)
        
        if #available(iOS 11.0, *)
        {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        headerImageView = UIImageView.init(frame: CGRect(x: 0, y: -200, width: SCREEN_WIDTH, height: 200))
        
        //bgImageView.contentMode = UIViewContentModeScaleAspectFill;//添加了这个属性表示等比例缩放，否则只缩放高度
        headerImageView.image = UIImage(named: "advertisement_1")
        tableView.addSubview(headerImageView)
        
        let imageView = UIImageView.init(frame: CGRect(x: 20, y: -70, width: 60, height: 60))
        imageView.image = UIImage(named: "user_image")
        imageView.backgroundColor = .white;
        tableView.addSubview(imageView)
        
        imageView.layer.masksToBounds = true;
        imageView.layer.cornerRadius = 30;
        imageView.layer.borderColor = BACKGROUND_VIEW_COLOR.cgColor;
        imageView.layer.borderWidth = 1;
        
        let label = UILabel.init(frame: CGRect(x: 90, y: -40, width: 100, height: 20))
        label.backgroundColor = .white;
        label.textAlignment = .center;
        label.textColor = .black;
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "黄金脆皮鱼"
        tableView.addSubview(label)
        
    }
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CellIdentifier")
        }
        cell?.textLabel?.text = "哈哈哈哈哈"
        return cell!
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if headerImageView == nil {
            return
        }
        
        let offset = scrollView.contentOffset;
        print(offset.y);
        //偏移从-200开始
        if offset.y < -200 {
            headerImageView.mj_y = offset.y;
            headerImageView.mj_h = abs(offset.y);
        }
        else if offset.y > -200 && offset.y < 0 {
            
            headerImageView.mj_y = offset.y;
            headerImageView.mj_h = 200 - (200 - abs(offset.y));
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
