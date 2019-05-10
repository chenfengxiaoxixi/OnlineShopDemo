//
//  CFTabBarController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addChildController(ChildController: CFHomePageController(), Title: "首页", DefaultImage: UIImage(named:"home_nor")!, SelectedImage: UIImage(named:"home_sel")!)
        addChildController(ChildController: CFClassificationController(), Title: "分类", DefaultImage: UIImage(named:"class_nor")!, SelectedImage: UIImage(named:"class_sel")!)
        addChildController(ChildController: CFShoppingCartController(), Title: "购物车", DefaultImage: UIImage(named:"shoppingCar_nor")!, SelectedImage: UIImage(named:"shoppingCar_sel")!)
        addChildController(ChildController: CFPersonalCenterController(), Title: "我的", DefaultImage: UIImage(named:"center_nor")!, SelectedImage: UIImage(named:"center_sel")!)
        
        self.delegate = self
        
    }
    
    func addChildController(ChildController child:UIViewController, Title title:String, DefaultImage defaultImage:UIImage, SelectedImage selectedImage:UIImage){
        child.tabBarItem = UITabBarItem(title: title, image: defaultImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysOriginal))
        child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .selected)
        
        let nav = UINavigationController(rootViewController: child)
        nav.setNavigationBarHidden(true, animated: true)
        self.addChild(nav)
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
