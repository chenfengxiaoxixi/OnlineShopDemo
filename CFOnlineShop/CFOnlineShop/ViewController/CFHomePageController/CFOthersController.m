//
//  CFOthersController.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/8/6.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFOthersController.h"

@interface CFOthersController ()

@end

@implementation CFOthersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //其他2
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100,100, 100, 20)];
    label.font = SYSTEMFONT(16);
    label.textColor = KDarkTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"没有内容";
    [self.view addSubview:label];
    
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
