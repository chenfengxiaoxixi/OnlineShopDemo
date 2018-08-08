//
//  CFBaseController.h
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/18.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFBaseController : UIViewController

@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIView *navigationBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;


- (void)setTitle:(NSString *)title;
- (void)showLeftBackButton;
@end
