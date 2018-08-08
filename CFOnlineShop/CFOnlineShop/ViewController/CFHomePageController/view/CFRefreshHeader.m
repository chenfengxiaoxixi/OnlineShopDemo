//
//  CFRefreshHeader.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/19.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFRefreshHeader.h"

@interface CFRefreshHeader ()

@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation CFRefreshHeader

//具体有哪些子类方法可以去MJRefreshComponent类中查看

- (void)prepare
{
    [super prepare];
    //创建UIImageView
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.image = [UIImage imageNamed:@"home_header"];
    //将该UIImageView添加到当前header中
    [self addSubview:_headerImageView];
    [self sendSubviewToBack:_headerImageView];
    //根据拖拽的情况自动切换透明度
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.textColor = KGrayTextColor;
    [self setTitle:@"下拉刷新" forState:(MJRefreshStateIdle)];
    //self.stateLabel.hidden = YES;
}


- (void)placeSubviews
{
    [super placeSubviews];
    
    _headerImageView.mj_x = 0;
    _headerImageView.mj_w = self.mj_w;
    _headerImageView.mj_h = self.mj_w;
    _headerImageView.mj_y = -_headerImageView.mj_h + 54;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

    CGPoint point = [change[@"new"] CGPointValue];
    //加入字符串判断是确保滑动过程中只执行一次
    if (point.y < pass150Offset && ![self.stateLabel.text isEqualToString:@"松开抽大奖"]) {
        NSLog(@"1");
        
        [self setTitle:@"松开抽大奖" forState:(MJRefreshStatePulling)];
    }
    else if (point.y < -54 && point.y > pass150Offset && ![self.stateLabel.text isEqualToString:@"松开立即刷新"])
    {
        [self setTitle:@"松开立即刷新" forState:(MJRefreshStatePulling)];
        NSLog(@"2");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
