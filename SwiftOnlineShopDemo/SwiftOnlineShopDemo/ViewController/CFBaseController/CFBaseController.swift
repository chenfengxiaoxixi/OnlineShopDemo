//
//  CFBaseController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFBaseController: UIViewController {
    
    var navigationView: UIView!
    var navigationBgView: UIView!
    var leftButton: UIButton!
    var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
     
        navigationView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: STATUS_AND_NAV_BAR_HEIGHT))
        navigationView.backgroundColor = UIColor.clear
        view.addSubview(navigationView)
        
        navigationBgView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: STATUS_AND_NAV_BAR_HEIGHT))
        navigationBgView.backgroundColor = UIColor.clear
        navigationView.addSubview(navigationBgView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.view.bringSubviewToFront(navigationView)
    }
    
    func setTitle(title:String) {
        
        let titleLabel = UILabel.init(frame: CGRect(x: navigationView.mj_w/2 - 50, y: navigationView.mj_h - 30, width: 100, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        titleLabel.text = title
        titleLabel.textAlignment = .center
        navigationView.addSubview(titleLabel)
        
    }

    func showLeftBackButton() {
        
        leftButton = UIButton(type:.custom)
        leftButton.frame = CGRect(x: 15, y: STATUSBAR_HEIGHT, width: 45, height: 35)
        leftButton.setImage(UIImage.init(named: "back_btn"), for:.normal)
        leftButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navigationView.addSubview(leftButton)
        
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
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
