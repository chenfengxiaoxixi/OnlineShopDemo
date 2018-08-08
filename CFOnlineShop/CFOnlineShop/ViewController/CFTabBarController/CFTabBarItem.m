//
//  CFTabBarItem.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/18.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFTabBarItem.h"

@implementation CFTabBarItem

- (id)initWithNomalImage:(UIImage *)nomalImage andSelectedImage:(UIImage *)selectedImage andTitle:(NSString *)title
{
    self = [super init];
    if(self)
    {
        self.backgroundColor=[UIColor clearColor];
        [self setImage:nomalImage forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:KDarkTextColor forState:UIControlStateSelected];
        [self setTitleColor:KGrayTextColor forState:UIControlStateNormal];
        self.titleLabel.font = SYSTEMFONT(12);
        self.imageEdgeInsets = UIEdgeInsetsMake(-8, 13, 8, -13);
        self.titleEdgeInsets = UIEdgeInsetsMake(14, -16, -14, 16);

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
