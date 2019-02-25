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
//获取分段title显示
- (NSArray *)getImagesWithArray;
@end

@interface CFCarouselScrollView : UIView

@property (nonatomic, weak) id<CFCarouselScrollViewDataSource> dataSource;

@end


