//
//  CFSegmentedControl.h
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/20.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFSegmentedControlDataSource <NSObject>
@required
//获取分段title显示
- (NSArray *)getSegmentedControlTitles;
@end

@class CFSegmentedControl;

@protocol CFSegmentedControlDelegate <NSObject>
@optional
- (void)control:(CFSegmentedControl *)control didSelectAtIndex:(NSInteger )index;
@end

@interface CFSegmentedControl : UIView

@property (nonatomic, weak) id <CFSegmentedControlDataSource> dataSource;
@property (nonatomic, weak) id <CFSegmentedControlDelegate> delegate;

- (void)didSelectIndex:(NSInteger )index;

@end
