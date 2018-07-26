//
//  CFHomeCollectionHeader.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/19.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFHomeCollectionHeader.h"
#import "SDCycleScrollView.h"

@implementation CFHomeCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *array = @[@"advertisement_1",@"advertisement_2",@"advertisement_3"];
        //本地加载图片的轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame imageNamesGroup:array];
        cycleScrollView.backgroundColor = kWhiteColor;
        cycleScrollView.autoScrollTimeInterval = 3;
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        cycleScrollView.currentPageDotColor = kRedColor;
        [self addSubview:cycleScrollView];
        
    }
    return self;
}

@end
