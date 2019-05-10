//
//  CFCarouselScrollView.h
//  CFOnlineShop
//
//  Created by chenfeng on 2019/2/25.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFCarouselScrollViewDataSource <NSObject>

@required
//获取image资源
- (NSArray *)getImagesWithArray;
@end

@interface CFCarouselScrollView : UIView

@property (nonatomic, weak) id<CFCarouselScrollViewDataSource> dataSource;

@end


