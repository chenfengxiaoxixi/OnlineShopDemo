//
//  CFOthersController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/26.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFOthersController: CFBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let label = UILabel.init(frame: CGRect(x: 100, y: 200, width: 100, height: 20))
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "其他"
        self.view.addSubview(label)
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
