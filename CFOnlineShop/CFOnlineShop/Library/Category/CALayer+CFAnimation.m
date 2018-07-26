//
//  CALayer+CFAnimation.m
//  SixTeenHourShoppingMall
//
//  Created by chenfeng on 2018/3/29.
//  Copyright © 2018年 TuoYuanCulture. All rights reserved.
//

#import "CALayer+CFAnimation.h"

@implementation CALayer (CFAnimation)

- (void)startAnimationWithKeyPath:(NSString *)keyPath andValues:(NSArray *)values andDuration:(CFTimeInterval)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = keyPath;
    animation.values = values;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.calculationMode = kCAAnimationCubic;
    animation.fillMode = kCAFillModeForwards;
    [self addAnimation:animation forKey:nil];
}

@end
