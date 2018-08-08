//
//  CALayer+CFAnimation.h
//  SixTeenHourShoppingMall
//
//  Created by chenfeng on 2018/3/29.
//  Copyright © 2018年 TuoYuanCulture. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (CFAnimation)

//动画
- (void)startAnimationWithKeyPath:(NSString *)keyPath andValues:(NSArray *)values andDuration:(CFTimeInterval)duration;

@end
