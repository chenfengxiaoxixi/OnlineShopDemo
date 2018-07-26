//
//  LPSemiModalView.h
//
//  Created by litt1e-p on 16/3/10.
//  Copyright © 2016年 itt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SemiModalViewWillCloseBlock)();
typedef void (^SemiModalViewDidCloseBlock)();

@interface LPSemiModalView : UIView

@property (nonatomic, copy) SemiModalViewWillCloseBlock semiModalViewWillCloseBlock;
@property (nonatomic, copy) SemiModalViewDidCloseBlock semiModalViewDidCloseBlock;

@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) BOOL narrowedOff;

- (id)initWithSize:(CGSize)size andBaseViewController:(UIViewController *)baseViewController;
- (void)close;
- (void)open;

@end
