//
//  CFTabBarController.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/18.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFTabBarController.h"
#import "CFHomePageController.h"
#import "CFClassificationController.h"
#import "CFShoppingCartController.h"
#import "CFPersonalCenterController.h"
#import "CFTabBarItem.h"

@interface CFTabBarController ()
{
    NSMutableArray *tabBarVCArray;
    NSMutableArray *tabBarItemArray;
    NSInteger       tabBarItemCount;
    NSInteger       msgCount;
}

@end

@implementation CFTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.hidden = YES;
    tabBarItemCount = 4;
    [self setNeedsStatusBarAppearanceUpdate];
    tabBarVCArray = [[NSMutableArray alloc]init];
    tabBarItemArray = [[NSMutableArray alloc]init];
    
    [self initTabBarItemView];
    
    CFHomePageController *homeVC = [[CFHomePageController alloc] init];
    homeVC.hidesBottomBarWhenPushed = NO;
    UINavigationController *homeVCNavi = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeVCNavi.delegate = self;
    homeVCNavi.navigationBar.hidden = YES;
    [tabBarVCArray addObject:homeVCNavi];
    
    CFClassificationController *classVC = [[CFClassificationController alloc] init];
    classVC.hidesBottomBarWhenPushed = NO;
    UINavigationController *classVCNavi = [[UINavigationController alloc]initWithRootViewController:classVC];
    classVCNavi.navigationBar.hidden = YES;
    classVCNavi.delegate = self;
    [tabBarVCArray addObject:classVCNavi];
    
    CFShoppingCartController *shopVC = [[CFShoppingCartController alloc] init];
    shopVC.hidesBottomBarWhenPushed = NO;
    UINavigationController *shopVCNavi = [[UINavigationController alloc]initWithRootViewController:shopVC];
    shopVCNavi.navigationBar.hidden = YES;
    shopVCNavi.delegate = self;
    [tabBarVCArray addObject:shopVCNavi];
    
    CFPersonalCenterController *myVC = [[CFPersonalCenterController alloc] init];
    myVC.hidesBottomBarWhenPushed = NO;
    UINavigationController *myVCNavi = [[UINavigationController alloc]initWithRootViewController:myVC];
    myVCNavi.navigationBar.hidden = YES;
    myVCNavi.delegate = self;
    [tabBarVCArray addObject:myVCNavi];
    
    self.viewControllers = tabBarVCArray;
    
    //默认选中
    [self tabBarItemClicked:[tabBarItemArray firstObject]];
    
}

- (void)initTabBarItemView
{
    _tabBarItemView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - TabbarHeight, Main_Screen_Width, TabbarHeight)];
    [self.view addSubview:_tabBarItemView];
    _tabBarItemView.backgroundColor = [UIColor whiteColor];
    
    UIView *tabBarItemTopShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 1)];
    tabBarItemTopShadow.backgroundColor = KLineGrayColor;
    [_tabBarItemView addSubview:tabBarItemTopShadow];
    

    CFTabBarItem *tabBarItem1 = [[CFTabBarItem alloc] initWithNomalImage:[UIImage imageNamed:@"home_nor"] andSelectedImage:[UIImage imageNamed:@"home_sel"] andTitle:@"主页"];
    if (IS_iPhoneX) {
        tabBarItem1.frame = CGRectMake(0, 0, _tabBarItemView.mj_w/tabBarItemCount, _tabBarItemView.mj_h);
    }
    else
    {
        tabBarItem1.frame = CGRectMake(0, 0, _tabBarItemView.mj_w/tabBarItemCount, 65);
    }
    tabBarItem1.selected = YES;
    [tabBarItem1 addTarget:self action:@selector(tabBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarItemView addSubview:tabBarItem1];
    [tabBarItemArray addObject:tabBarItem1];
    

    CFTabBarItem *tabBarItem2 = [[CFTabBarItem alloc] initWithNomalImage:[UIImage imageNamed:@"class_nor"] andSelectedImage:[UIImage imageNamed:@"class_sel"] andTitle:@"分类"];
    if (IS_iPhoneX) {
        tabBarItem2.frame = CGRectMake(MaxX(tabBarItem1), 0, _tabBarItemView.mj_w/tabBarItemCount, _tabBarItemView.mj_h);
    }
    else
    {
        tabBarItem2.frame = CGRectMake(MaxX(tabBarItem1), 0, _tabBarItemView.mj_w/tabBarItemCount, 65);
    }
    [tabBarItem2 addTarget:self action:@selector(tabBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarItemView addSubview:tabBarItem2];
    [tabBarItemArray addObject:tabBarItem2];
    
    CFTabBarItem *tabBarItem3 = [[CFTabBarItem alloc] initWithNomalImage:[UIImage imageNamed:@"shoppingCar_nor"] andSelectedImage:[UIImage imageNamed:@"shoppingCar_sel"] andTitle:@"购物车"];
    tabBarItem3.tag = 102;
    if (IS_iPhoneX) {
        tabBarItem3.frame = CGRectMake(MaxX(tabBarItem2), 0, _tabBarItemView.mj_w/tabBarItemCount, _tabBarItemView.mj_h);
    }
    else
    {
        tabBarItem3.frame = CGRectMake(MaxX(tabBarItem2), 0, _tabBarItemView.mj_w/tabBarItemCount, 65);
    }
    [tabBarItem3 addTarget:self action:@selector(tabBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarItemView addSubview:tabBarItem3];
    [tabBarItemArray addObject:tabBarItem3];
    
    CFTabBarItem *tabBarItem4 = [[CFTabBarItem alloc] initWithNomalImage:[UIImage imageNamed:@"center_nor"] andSelectedImage:[UIImage imageNamed:@"center_sel"] andTitle:@"我的"];
    if (IS_iPhoneX) {
        tabBarItem4.frame = CGRectMake(MaxX(tabBarItem3), 0, _tabBarItemView.mj_w/tabBarItemCount, _tabBarItemView.mj_h);
    }
    else
    {
        tabBarItem4.frame = CGRectMake(MaxX(tabBarItem3), 0, _tabBarItemView.mj_w/tabBarItemCount, 65);
    }
    [tabBarItem4 addTarget:self action:@selector(tabBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarItemView addSubview:tabBarItem4];
    [tabBarItemArray addObject:tabBarItem4];
    
}

- (void)tabBarItemClicked:(CFTabBarItem*)sender
{
    if (self.selectedIndex == [tabBarItemArray indexOfObject:sender]) {
        return;
    }
    
    for (CFTabBarItem *btn in tabBarItemArray) {
        btn.selected = (btn==sender);
    }

    [sender.layer startAnimationWithKeyPath:@"transform.scale"
                                  andValues:@[@1.0,@1.3,@0.9,@1.05,@1.0]
                                andDuration:0.6f];
    
    self.selectedIndex = [tabBarItemArray indexOfObject:sender];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.tabBar.hidden = YES;
    WeakSelf(self);
    if (viewController.hidesBottomBarWhenPushed) {
        [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
            weakself.tabBarItemView.alpha = 0;
            weakself.tabBarItemView.mj_y = Main_Screen_Height;
            
        }];
    }else{
        [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
            weakself.tabBarItemView.alpha = 1;
            weakself.tabBarItemView.mj_y = Main_Screen_Height - TabbarHeight;
        }];
    }
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
