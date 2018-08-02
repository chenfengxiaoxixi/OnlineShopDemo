//
//  CFEditCollectionCell.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/24.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFEditCollectionCell.h"

#define kDeleteBtnWidth 70

@interface CFEditCollectionCell ()<UIGestureRecognizerDelegate>
{
    CGPoint origin;
    BOOL isLeft;
    UIButton *deleteButton;
}

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation CFEditCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _status = CFEditCollectionCellStatusWithNormal;
        
        self.contentView.backgroundColor = kWhiteColor;
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidPan:)];
        _pan.delegate = self;
        
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        _tap.delegate = self;
        [self.contentView addGestureRecognizer:_tap];
    }
    return self;
}

- (void)configCollectionCellType:(CFEditCollectionCellType )type
{
    [self.contentView addGestureRecognizer:_pan];
    
    if (type == CFEditCollectionCellTypeWithDelete) {

        if (deleteButton == nil) {
            deleteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            deleteButton.frame = CGRectMake(self.mj_w - kDeleteBtnWidth, 0, kDeleteBtnWidth, self.mj_h);
            [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:(UIControlStateNormal)];
            deleteButton.backgroundColor = kRedColor;
            [self addSubview:deleteButton];
            [self sendSubviewToBack:deleteButton];
        }
    }
    else if (type == CFEditCollectionCellTypeWithNone)
    {
        //点击手势保留
        [self.contentView removeGestureRecognizer:_pan];
    }
}

- (void)deleteAction:(UIButton *)sender
{
    if (_deleteButtonAction != nil) {
        [self hiddenButtonsWithAnimation];
        _deleteButtonAction(sender);
    }
}

- (void)hiddenButtonsWithAnimation
{
    if (self.contentView.mj_x != 0) {
        [UIView animateWithDuration:0.15 animations:^{
            self.contentView.mj_x = 0;
            } completion:^(BOOL finished) {
                _status = CFEditCollectionCellStatusWithNormal;
        }];
    }
}

- (void)showButtonsWithAnimation
{
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.mj_x = -kDeleteBtnWidth*1;
        } completion:^(BOOL finished) {
            _status = CFEditCollectionCellStatusWithEdit;
    }];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_status == CFEditCollectionCellStatusWithEdit) {
        [self hiddenButtonsWithAnimation];
    }
}

- (void)panGestureDidPan:(UIPanGestureRecognizer *)panGesture {
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            origin = [panGesture translationInView:self];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self];
            isLeft = (translation.x < 0);
            
            NSLog(@"panGesture.view.mj_x = %lf",translation.x);
            
            if (isLeft) {
                //多加了30的缓冲偏移量,因为translation.x并不一直是等差变化，滑动速度越快，中间变化量越大
                if (ABS(translation.x) <= kDeleteBtnWidth*1 + 30 &&
                    _status == CFEditCollectionCellStatusWithNormal) {
                    panGesture.view.mj_x = translation.x;
                    
                }
                //左滑未松开然后又向右滑动
                else if (ABS(translation.x) <= 30 &&
                         _status == CFEditCollectionCellStatusWithEdit)
                {
                    panGesture.view.mj_x = - (kDeleteBtnWidth*1 - translation.x);
                }
                NSLog(@"左");
            }
            else
            {
                if (ABS(translation.x) <= kDeleteBtnWidth*1 + 30 &&
                    _status == CFEditCollectionCellStatusWithEdit) {
                    panGesture.view.mj_x = - (kDeleteBtnWidth*1 - translation.x);
                }
                //右滑未松开然后又向左滑动
                else if (ABS(translation.x) <= 30 &&
                         _status == CFEditCollectionCellStatusWithNormal &&
                         panGesture.view.mj_x != 0)
                {
                    panGesture.view.mj_x = translation.x;
                }
                NSLog(@"右");
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"end");
            
            if (isLeft) {
                [self showButtonsWithAnimation];
            }
            else
            {
                [self hiddenButtonsWithAnimation];
            }
        }
            break;
        default:
            break;
            
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //self.superview表示collectionView
    //objc_getAssociatedObject和objc_setAssociatedObject类似字典中的key-value形式
    //用self.superview做主对象，用来存放cell子对象（为什么这样用，实在不了解的关联函数的可以百度查一查）
    CFEditCollectionCell *currentCell = objc_getAssociatedObject(self.superview, @"currentCell");
    
    if (gestureRecognizer == _pan &&
        [gestureRecognizer.view isKindOfClass:[UIView class]]) {
        
        CGPoint translation = [_pan translationInView:self];

        objc_setAssociatedObject(self.superview, @"currentCell", self, OBJC_ASSOCIATION_ASSIGN);
        
        //判断滑动
        if (fabs(translation.y) > fabs(translation.x))//表示竖着滑动
        {
            //由于collectionView有边距，触摸到collectionView边距时，这个方法不会生效，所以滑动的时候在外部判断隐藏
            //[currentCell hiddenButtonsWithAnimation];//关闭当前左滑的cell
            return NO;//禁止cell的竖向滑动，使其响应collectionview的上下滚动
        }
        
        if (currentCell != self && currentCell != nil) {
            [currentCell hiddenButtonsWithAnimation];
        }
        
        //表示横着滑动
        return YES;
    }
    else if (gestureRecognizer == _tap &&
             [gestureRecognizer.view isKindOfClass:[UIView class]])
    {
        //判断如果当前没有滑动的cell，则关闭cell内部点击事件，响应外部didSelectItemAtIndexPath事件
        //x坐标不为0时，表示当前cell处于左滑状态
        if (currentCell.status == CFEditCollectionCellStatusWithEdit) {
            [currentCell hiddenButtonsWithAnimation];//关闭当前左滑的cell
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if ([gestureRecognizer.view isKindOfClass:[UICollectionView class]])
    {
        return YES;
    }
    
    return NO;
}

@end
