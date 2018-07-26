//
//  CFBaseController.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/18.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFBaseController.h"
#import "CFTabBarController.h"

@interface CFBaseController ()

@end

@implementation CFBaseController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = KBackgroundColor;
    
    [self setNavView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //适配左滑时tabbar显示出来的问题
    if (self.hidesBottomBarWhenPushed) {
        if ([self.tabBarController isKindOfClass:[CFTabBarController class]]) {
            
            CFTabBarController *tabBar = (CFTabBarController *)self.tabBarController;
            [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
                tabBar.tabBarItemView.mj_y = Main_Screen_Height;
            }];
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:_navigationView];//始终放在最上层
}

- (void)setNavView
{
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, TopHeight)];
    _navigationView.backgroundColor = kClearColor;
    [self.view addSubview:_navigationView];
    
    _navigationBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, TopHeight)];
    _navigationBgView.backgroundColor = kClearColor;
    [_navigationView addSubview:_navigationBgView];
}

- (void)setTitle:(NSString *)title
{
    [_navigationView addSubview:self.titleLabel];
    _titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_navigationView.mj_w/2 - 50, _navigationView.mj_h - 30, 100, 20)];
        _titleLabel.font = SYSTEMFONT(16);
        _titleLabel.textColor = KDarkTextColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (void)showLeftBackButton
{
    _leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _leftButton.frame = CGRectMake(15, StatusBarHeight + 5, 45, 35);
    [_leftButton setImage:[UIImage imageNamed:@"back_btn"] forState:(UIControlStateNormal)];
    [_leftButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_navigationView addSubview:_leftButton];
}


#pragma mark - action

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
