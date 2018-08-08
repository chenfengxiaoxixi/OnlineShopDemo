//
//  CFShoppingCartHeaderView.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/26.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFShoppingCartHeaderView.h"

@implementation CFShoppingCartHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.mj_w, 35)];
        _label.font = SYSTEMFONT(14);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = KDarkTextColor;
        _label.text = @"推荐商品";
        [self addSubview:_label];
        
    }
    return self;
}

@end
