//
//  LPSemiModalView.m
//
//  Created by litt1e-p on 16/3/10.
//  Copyright © 2016年 itt1e-p. All rights reserved.
//

#import "LPSemiModalView.h"
#import <QuartzCore/QuartzCore.h>

@interface LPSemiModalView ()

@property (strong, nonatomic) UIControl *closeControl;
@property (strong, nonatomic) UIImageView *maskImageView;
@property (nonatomic, strong) UIViewController *baseViewController;

@end

@implementation LPSemiModalView

+ (UIImage *)snapshotWithWindow
{
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, YES, 2);
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

- (void)open
{
    if (!self.narrowedOff) {
        //self.contentView.hidden = YES;
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.maskImageView.layer.zPosition = -10000;
        
        self.maskImageView.image = [self.class snapshotWithWindow];
        if (self.baseViewController) {
            [self.baseViewController.view bringSubviewToFront:self];
        }
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 0.5;
            self.contentView.frame = CGRectMake(0,
                                                [[UIScreen mainScreen] bounds].size.height - self.contentView.bounds.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        }];
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DRotate(t, 7/90.0 * M_PI_2, 1, 0, 0);
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    [self transNavigationBarToHide:YES];
                }
            }
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
            }];
        }];
    } else {
        self.maskImageView.image = [self.class snapshotWithWindow];
        if (self.baseViewController) {
            [self.baseViewController.view bringSubviewToFront:self];
        }
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 0.25;
            self.contentView.frame = CGRectMake(0,
                                                [[UIScreen mainScreen] bounds].size.height - self.contentView.bounds.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    self.baseViewController.navigationController.navigationBarHidden = YES;
                }
            }
        }];
    }
}

- (void)close
{
    if (self.semiModalViewWillCloseBlock) {
        self.semiModalViewWillCloseBlock();
    }
    if (!self.narrowedOff) {
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,
                                                self.frame.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            if (self.semiModalViewDidCloseBlock) {
                self.semiModalViewDidCloseBlock();
            }
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    [self transNavigationBarToHide:NO];
                }
                [self.baseViewController.view sendSubviewToBack:self];
            }
        }];
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
            self.maskImageView.layer.transform = CATransform3DRotate(t, 7/90.0 * M_PI_2, 1, 0, 0);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, 0, 0);
            }];
        }];
    } else {
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,
                                                self.frame.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            if (self.semiModalViewDidCloseBlock) {
                self.semiModalViewDidCloseBlock();
            }
            if (self.baseViewController) {
                [self.baseViewController.view sendSubviewToBack:self];
                if (self.baseViewController.navigationController) {
                    self.baseViewController.navigationController.navigationBarHidden = NO;
                }
            }
        }];
    }
}

- (void)transNavigationBarToHide:(BOOL)hide
{
    if (hide) {
        CGRect frame = self.baseViewController.navigationController.navigationBar.frame;
        [self setNavigationBarOriginY:-frame.size.height animated:NO];
    } else {
        [self setNavigationBarOriginY:[self statusBarHeight] animated:NO];
    }
}

- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated
{
    CGFloat statusBarHeight         = [self statusBarHeight];
    UIWindow *appKeyWindow          = [UIApplication sharedApplication].keyWindow;
    UIView *appBaseView             = appKeyWindow.rootViewController.view;
    CGRect viewControllerFrame      = [appBaseView convertRect:appBaseView.bounds toView:appKeyWindow];
    CGFloat overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y;
    CGRect frame                    = self.baseViewController.navigationController.navigationBar.frame;
    frame.origin.y                  = y;
    CGFloat navBarHiddenRatio       = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0;
    CGFloat alpha                   = MAX(1.f - navBarHiddenRatio, 0.000001f);
    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
        self.baseViewController.navigationController.navigationBar.frame = frame;
        NSUInteger index = 0;
        for (UIView *view in self.baseViewController.navigationController.navigationBar.subviews) {
            index++;
            if (index == 1 || view.hidden || view.alpha <= 0.0f) continue;
            view.alpha = alpha;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            UIColor *tintColor = self.baseViewController.navigationController.navigationBar.tintColor;
            if (tintColor) {
                self.baseViewController.navigationController.navigationBar.tintColor = [tintColor colorWithAlphaComponent:alpha];
            }
        }
    }];
}

- (CGFloat)statusBarHeight
{
    CGSize statuBarFrameSize = [UIApplication sharedApplication].statusBarFrame.size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        return statuBarFrameSize.height;
    }
    return UIInterfaceOrientationIsPortrait(self.baseViewController.interfaceOrientation) ? statuBarFrameSize.height : statuBarFrameSize.width;
}

- (void)contentViewHeight:(float)height
{
    if (height > [UIScreen mainScreen].bounds.size.height) {
        height = [UIScreen mainScreen].bounds.size.height;
    }
    self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, height);
}

- (CGRect)contentViewFrameWithSize:(CGSize)size
{
    if (size.height > [UIScreen mainScreen].bounds.size.height) {
        size.height = [UIScreen mainScreen].bounds.size.height;
    }
    if (size.width > [UIScreen mainScreen].bounds.size.width) {
        size.width = [UIScreen mainScreen].bounds.size.width;
    }
    return CGRectMake(0, self.frame.size.height, self.frame.size.width, size.height);
}

- (id)initWithSize:(CGSize)size andBaseViewController:(UIViewController *)baseViewController
{
    if (self = [super init]) {
        self.frame           = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.maskImageView];
        [self addSubview:self.closeControl];
        [self addSubview:self.contentView];
        self.contentView.frame  = [self contentViewFrameWithSize:size];
        self.baseViewController = baseViewController;
        if (baseViewController) {
            [baseViewController.view insertSubview:self atIndex:0];
            [baseViewController.view sendSubviewToBack:self];
        }
    }
    return self;
}

#pragma mark - lazy loads 📌
- (UIView *)contentView
{
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    self.frame.size.height,
                                                                    self.frame.size.width,
                                                                    self.frame.size.height)];
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
    }
    return _contentView;
}

- (UIControl *)closeControl
{
    if (!_closeControl) {
        UIControl *closeControl             = [[UIControl alloc] initWithFrame:self.bounds];
        closeControl.userInteractionEnabled = NO;
        closeControl.backgroundColor        = [UIColor clearColor];
        [closeControl addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        self.closeControl = closeControl;
    }
    return _closeControl;
}

- (UIImageView *)maskImageView
{
    if (!_maskImageView) {
        self.maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.frame.size.width,
                                                                           self.frame.size.height)];
    }
    return _maskImageView;
}

@end
