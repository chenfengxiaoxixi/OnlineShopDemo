//
//  CFEditCollectionCell.h
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/24.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CFEditCollectionCellType) {
    
    CFEditCollectionCellTypeWithNone = 0,
    CFEditCollectionCellTypeWithDelete,
    
};

@interface CFEditCollectionCell : UICollectionViewCell

@property (nonatomic, strong) void (^deleteButtonAction)(UIButton *button);

- (void)configCollectionCellType:(CFEditCollectionCellType )type;

- (void)hiddenButtonsWithAnimation;


@end
