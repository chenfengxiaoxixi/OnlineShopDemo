//
//  GlobalConfigDefinition.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.size.height

let IS_IPHONE_X = STATUSBAR_HEIGHT > 20 ? true : false

let STATUS_AND_NAV_BAR_HEIGHT:CGFloat = IS_IPHONE_X == true ? 88.0 : 64.0
let NAVBAR_HEIGHT:CGFloat = 44
let TABBAR_HEIGHT:CGFloat = IS_IPHONE_X == true ? 83.0 : 49.0
let BOTTOM_SAFE_HEIGHT:CGFloat = IS_IPHONE_X == true ? 34 : 0

/*
 * 颜色
 */

let VERY_LIGHT_COLOR = UIColor(red: 228.0/255, green: 228.0/255, blue: 228.0/255, alpha: 1.0)
let BACKGROUND_VIEW_COLOR = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1.0)

