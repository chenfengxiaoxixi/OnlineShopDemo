//
//  CFClassificationCell.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/24.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFClassificationCell.h"

@implementation CFClassificationCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.mj_w, self.mj_w)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _titleStr = [[UILabel alloc] initWithFrame:CGRectMake(15, self.mj_w + 15, self.mj_w - 30, 20)];
        _titleStr.font = SYSTEMFONT(14);
        _titleStr.textColor = KDarkTextColor;
        [self.contentView addSubview:_titleStr];
        
    }
    
    return self;
}

@end
