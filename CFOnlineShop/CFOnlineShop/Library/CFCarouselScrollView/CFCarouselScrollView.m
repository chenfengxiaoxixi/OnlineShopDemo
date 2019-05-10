//
//  CFCarouselScrollView.m
//  CFOnlineShop
//
//  Created by chenfeng on 2019/2/25.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "CFCarouselScrollView.h"

@interface CFCarouselScrollView ()<UIScrollViewDelegate>
{
    UIScrollView *bgScrollView;
    UIScrollView *currentScrollView;
    NSInteger currentIndex;
    NSInteger total;
    CGFloat endOffsetX;
    UILabel *pageLabel;
}

@end

@implementation CFCarouselScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //底层scrollView
        bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgScrollView.pagingEnabled = YES;
        bgScrollView.delegate = self;
        bgScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:bgScrollView];
        endOffsetX = 0;
        currentIndex = 0;
    }
    return self;
}

- (void)setDataSource:(id<CFCarouselScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    NSArray *array = [_dataSource getImagesWithArray];
    
    if ([array count] == 0) {
        return;
    }
    
    bgScrollView.contentSize = CGSizeMake(array.count * self.mj_w, self.mj_h);
    
    total = array.count;
    
    [self showPageCount];
    
    for (int i = 0; i < array.count; i++) {
        
        id image = array[i];
        
        if ([image isKindOfClass:[NSString class]]) {
            
            //嵌套的scrollView，用来包住每个imageview；实现的遮盖效果，实际是操作的imageview在childScrollView上的偏移
            UIScrollView *childScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.mj_w * i, 0, self.mj_w, self.mj_h)];
            childScrollView.tag = 100 + i;
            [bgScrollView addSubview:childScrollView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:image];
            [childScrollView addSubview:imageView];
            
            if (i == 0) {
                currentScrollView = childScrollView;
            }
        }
        //其他类型的图片类型，如url，UIImage等
        else
        {
            
        }
    }
}

- (void)showPageCount
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.mj_w/2 - 30, self.mj_h - 60, 60, 25)];
    view.backgroundColor = kClearColor;
    [self addSubview:view];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 60, 25)];
    grayView.backgroundColor = kBlackColor;
    grayView.alpha = 0.4;
    grayView.layer.cornerRadius = 12.5;
    [view addSubview:grayView];
    
    pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    pageLabel.textColor = kWhiteColor;
    pageLabel.font = SYSTEMFONT(12);
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,total];
    [view addSubview:pageLabel];
    
}

#pragma mark -- <UIScrollViewDelegate>

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint contentOffset = *targetContentOffset;
    
    currentIndex = contentOffset.x/self.mj_h;
    
    endOffsetX = contentOffset.x;
    
    pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,total];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算childScrollView的起始偏移，使每个childScrollView始终在0~self.mj_w范围偏移
    CGFloat childScrollViewOffset = scrollView.contentOffset.x - self.mj_w * currentIndex;
    //底部scrollView总偏移移
    CGFloat scrollViewOffset = scrollView.contentOffset.x;
    //向左滑动
    if (scrollViewOffset >= endOffsetX) {
        NSLog(@"向左滑动");
        //向左滑动时，执行减速的视图为当前childScrollView
        currentScrollView = [bgScrollView viewWithTag:100 + currentIndex];

        if (scrollView == bgScrollView){
            //因为currentScrollView是放在self上的，self向左速度为1，实际上currentScrollView的速度也是1，此处认为设置currentScrollView往反方向走1/2的速度，最后就形成了视觉差！
            currentScrollView.contentOffset = CGPointMake(-childScrollViewOffset/2.0f, currentScrollView.contentOffset.y);
        }
    }
    else
    {
        NSLog(@"向右滑动");
        if (scrollViewOffset < 0) {
            return;
        }
        
        childScrollViewOffset = scrollView.contentOffset.x - self.mj_w * (currentIndex - 1);
        
        //向右滑动时，执行减速的视图为上一个childScrollView
        currentScrollView = [bgScrollView viewWithTag:100 + currentIndex - 1];

        if (scrollView == bgScrollView) {
            //因为currentScrollView是放在self上的，self向左速度为1，实际上currentScrollView的速度也是1，此处认为设置currentScrollView往反方向走1/2的速度，最后就形成了视觉差！
            currentScrollView.contentOffset = CGPointMake(-childScrollViewOffset/2.0f, currentScrollView.contentOffset.y);
        }
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
