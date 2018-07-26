//
//  CFHomeCollectionHeaderTwo.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/23.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFHomeCollectionHeaderTwo.h"
#import "GYRollingNoticeView.h"
#import "CFHomeHeaderTwoCell.h"


@interface CFHomeCollectionHeaderTwo ()<GYRollingNoticeViewDataSource, GYRollingNoticeViewDelegate>
{
    NSArray *_arr1;
    GYRollingNoticeView *_noticeView1;
}

@end

@implementation CFHomeCollectionHeaderTwo

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        GYRollingNoticeView *noticeView = [[GYRollingNoticeView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
        noticeView.dataSource = self;
        noticeView.delegate = self;
        [self addSubview:noticeView];
        
        noticeView.backgroundColor = [UIColor lightGrayColor];
        
        _arr1 = @[@"小米千元全面屏：抱歉，久等！625献上",
                  @"可怜狗狗被抛弃，苦苦等候主人半年",
                  @"三星中端新机改名，全面屏火力全开",
                  @"学会这些，这5种花不用去花店买了",
                  @"华为nova2S发布，剧透了荣耀10？"
                  ];
        
        _noticeView1 = noticeView;
        [noticeView registerClass:[GYNoticeViewCell class] forCellReuseIdentifier:@"GYNoticeViewCell"];
        [noticeView registerClass:[CFHomeHeaderTwoCell class] forCellReuseIdentifier:@"CFHomeHeaderTwoCell"];
    
        [noticeView reloadDataAndStartRoll];
        
    }
    return self;
}

- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView
{
    return _arr1.count;
    
}

- (__kindof GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index
{
    // 普通用法，只有一行label滚动显示文字
    // normal use, only one line label rolling
    if (rollingView == _noticeView1) {
        if (index < 3) {
            GYNoticeViewCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"GYNoticeViewCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"第2种cell %@", _arr1[index]];
            cell.contentView.backgroundColor = kWhiteColor;
            
            return cell;
        }else {
            
            CFHomeHeaderTwoCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"CFHomeHeaderTwoCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"第1种cell %@", _arr1[index]];
            cell.contentView.backgroundColor = kWhiteColor;
            return cell;
        }
    }
    
    return nil;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index
{
    NSLog(@"点击的index: %ld",(long)index);
}

@end
