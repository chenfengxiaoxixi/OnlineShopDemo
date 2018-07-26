//
//  CFDetailInfoController.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/19.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFDetailInfoController.h"
#import "LPSemiModalView.h"
#import "CFSegmentedControl.h"
#import "CFDetailView.h"

@interface CFDetailInfoController ()<CFSegmentedControlDataSource,CFSegmentedControlDelegate,UIScrollViewDelegate>

//动画缩放视图
@property (nonatomic, strong) LPSemiModalView *narrowedModalView;

@property (nonatomic, strong) CFSegmentedControl *segmentedControl;

//能左右滑动的scrollview
@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) CFDetailView *detailView;

@property (nonatomic, strong) NSArray *segmentTitles;

@end

@implementation CFDetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _segmentTitles = @[@"详情",@"活动",@"其他"];
    
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 0;
    [self setSegmentedControl];
    [self showLeftBackButton];
    [self setBgScrollview];
    [self setShadowAnimationView];
    [self setDetailView];
}

- (void)setBgScrollview
{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _bgScrollView.delegate = self;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.contentSize = CGSizeMake(Main_Screen_Width * [_segmentTitles count], Main_Screen_Height);
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.bounces = NO;
    [self.view addSubview:_bgScrollView];
}

- (void)setSegmentedControl
{
    //注意宽度要留够，不然title显示不完，title宽度是计算出来的。代码并不复杂，可以根据需要去内部进行修改
    _segmentedControl = [[CFSegmentedControl alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - (60 * [_segmentTitles count])/2, TopHeight - 40, 60 * [_segmentTitles count], 40)];
    _segmentedControl.delegate = self;
    _segmentedControl.dataSource = self;
    _segmentedControl.alpha = 0;
    [self.navigationView addSubview:_segmentedControl];
}

- (void)setShadowAnimationView
{
    _narrowedModalView = [[LPSemiModalView alloc] initWithSize:CGSizeMake(Main_Screen_Width, 300) andBaseViewController:self.navigationController];
    _narrowedModalView.contentView.backgroundColor = kWhiteColor;
    
    //显示内容在contentView上添加
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_narrowedModalView.contentView.mj_w/2 - 50, 100, 100, 20)];
    label.textColor = KDarkTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SYSTEMFONT(16);
    label.text = @"暂无内容";
    [_narrowedModalView.contentView addSubview:label];
}

- (void)setDetailView
{
    //详情
    _detailView = [[CFDetailView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) image:_image];
    [_bgScrollView addSubview:_detailView];
    WeakSelf(self);
    //tableview滑动时控制导航栏的显示
    [_detailView setScrollViewDidScroll:^(UIScrollView *scrollView) {
        if (scrollView == weakself.detailView.tableView){
            
            if (scrollView.mj_offsetY > 0 && scrollView.mj_offsetY < 60) {
                
                weakself.navigationBgView.alpha = 1 * (scrollView.mj_offsetY / 60.f);
                weakself.segmentedControl.alpha = weakself.navigationBgView.alpha;
            }
            else if (scrollView.mj_offsetY <= 0)
            {
                weakself.navigationBgView.alpha = 0;
                weakself.segmentedControl.alpha = weakself.navigationBgView.alpha;
            }
            else if (scrollView.mj_offsetY > 40)
            {
                if (weakself.navigationBgView.alpha != 1) {
                    weakself.navigationBgView.alpha = 1;
                    weakself.segmentedControl.alpha = weakself.navigationBgView.alpha;
                }
            }
            
        }
    }];
    [_detailView setAddActionWithBlock:^{
        [weakself.narrowedModalView open];
    }];
    
    //其他1
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width + 100,100, 100, 20)];
    label.font = SYSTEMFONT(16);
    label.textColor = KDarkTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"没有内容";
    [_bgScrollView addSubview:label];
    
    //其他2
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width*2 + 100,100, 100, 20)];
    label2.font = SYSTEMFONT(16);
    label2.textColor = KDarkTextColor;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"没有内容";
    [_bgScrollView addSubview:label2];
}

#pragma mark -- UIScrollViewDelegate 用于控制头部视图滑动的视差效果

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bgScrollView) {
        
        NSInteger index = scrollView.mj_offsetX/Main_Screen_Width;
        
        [_segmentedControl didSelectIndex:index];
        WeakSelf(self);
        if (index == 0) {
            if (_detailView.tableView.mj_offsetY >= 0 && _detailView.tableView.mj_offsetY < 60) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    weakself.navigationBgView.alpha = 1 * (weakself.detailView.tableView.mj_offsetY / 60.f);
                    weakself.segmentedControl.alpha = weakself.navigationBgView.alpha;
                }];
            }
        }
        else if (index >= 1)
        {
            [UIView animateWithDuration:0.25 animations:^{
                weakself.navigationBgView.alpha = 1;
                weakself.segmentedControl.alpha = weakself.navigationBgView.alpha;
            }];
        }
    }
}

#pragma mark -- SegmentedControlDelegate & datasource

- (NSArray *)getSegmentedControlTitles
{
    return _segmentTitles;
}

- (void)control:(CFSegmentedControl *)control didSelectAtIndex:(NSInteger)index
{
    [_bgScrollView setContentOffset:CGPointMake(Main_Screen_Width * index, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
