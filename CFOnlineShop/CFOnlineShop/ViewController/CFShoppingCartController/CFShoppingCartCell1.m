//
//  CFShoppingCartCell1.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/25.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFShoppingCartCell1.h"

@implementation CFShoppingCartCell1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _titleStr = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_imageView) + 15, 15, 150, 20)];
        _titleStr.font = SYSTEMFONT(14);
        _titleStr.textColor = KDarkTextColor;
        [self.contentView addSubview:_titleStr];
        
    }
    
    return self;
}

@end
