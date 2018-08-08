//
//  CFDetailViewController.h
//  CFOnlineShop
//
//  Created by chenfeng on 2018/8/6.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFBaseController.h"

@interface CFDetailViewController : CFBaseController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) void (^addActionWithBlock)(void);

@property (nonatomic, strong) void (^scrollViewDidScroll)(UIScrollView *scrollView);

@end
