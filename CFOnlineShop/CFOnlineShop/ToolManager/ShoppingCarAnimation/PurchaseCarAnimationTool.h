//
//  PurchaseCarAnimationTool.h
//  PruchaseCarAnimation
//
//  Created by zhenyong on 16/8/17.
//  Copyright © 2016年 com.demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^animationFinisnBlock)(BOOL finish);
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface PurchaseCarAnimationTool : NSObject
@property (strong , nonatomic) CALayer *layer;
@property (copy , nonatomic) animationFinisnBlock animationFinisnBlock;
/**
 *  初始化
 *
 *  @return <#return value description#>
 */
+ (instancetype)shareTool;
/**
 *  开始动画
 *
 *  @param view        添加动画的view
 *  @param rect        view 的绝对frame
 *  @param finishPoint 下落的位置
 *  @param finishBlock 动画完成回调
 */
- (void)startAnimationandView:(UIView *)view
                         rect:(CGRect)rect
                  finisnPoint:(CGPoint)finishPoint
                  finishBlock:(animationFinisnBlock)completion;
/**
 *  摇晃动画
 *
 *  @param shakeView <#shakeView description#>
 */
+ (void)shakeAnimation:(UIView *)shakeView;
@end
