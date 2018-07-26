//
//  CFTabBarController.h
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/18.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFTabBarController : UITabBarController <UINavigationControllerDelegate>

//底部自定义tabBarView
@property (nonatomic, strong) UIView *tabBarItemView;

@end
