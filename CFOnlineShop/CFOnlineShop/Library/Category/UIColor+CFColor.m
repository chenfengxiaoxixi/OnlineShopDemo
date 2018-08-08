//
//  UIColor+CFColor.m
//  SixTeenHourShoppingMall
//
//  Created by chenfeng on 2018/3/29.
//  Copyright © 2018年 TuoYuanCulture. All rights reserved.
//

#import "UIColor+CFColor.h"

@implementation UIColor (CFColor)

+ (UIColor *)colorOfHex:(int)value{
    float red   = ((value & 0xFF0000) >> 16) / 255.0;
    float green = ((value & 0xFF00) >> 8) / 255.0;
    float blue  = (value & 0xFF) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
