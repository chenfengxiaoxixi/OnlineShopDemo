//
//  CFHomeCollectionCell.h
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/18.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFHomeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleStr;

@property (nonatomic, strong) void (^addToShoppingCar)(UIImageView *imageView);

@end
