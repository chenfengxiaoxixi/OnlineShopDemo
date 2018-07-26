//
//  CFDetailView.h
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/20.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFDetailView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

@property (nonatomic, strong) void (^addActionWithBlock)(void);

@property (nonatomic, strong) void (^scrollViewDidScroll)(UIScrollView *scrollView);

@end
