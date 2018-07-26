//
//  UIColor+CFColor.h
//  SixTeenHourShoppingMall
//
//  Created by chenfeng on 2018/3/29.
//  Copyright © 2018年 TuoYuanCulture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CFColor)

//根据颜色值获取颜色
+ (UIColor *)colorOfHex:(int)value;

@end
