//
//  CFPersonalCenterController.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/18.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFPersonalCenterController.h"

@interface CFPersonalCenterController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *bgImageView;
    UIView *header;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CFPersonalCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"我的"];
    self.navigationView.backgroundColor = kWhiteColor;
    [self setUI];
}

- (void)setUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TopHeight - TabbarHeight)];
    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);//使table上面空出200空白
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,-200, Main_Screen_Width, 200)];
    bgImageView.userInteractionEnabled = YES;
    //bgImageView.contentMode = UIViewContentModeScaleAspectFill;//添加了这个属性表示等比例缩放，否则只缩放高度
    bgImageView.image = [UIImage imageNamed:@"advertisement_1"];
    [_tableView addSubview:bgImageView];
    
    //其他控件也可以添加到_tableView的空白处，随tableview和伸缩动画联动
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,-100,100, 30)];
    label.backgroundColor = kRedColor;
    [_tableView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20,-150,100, 20)];
    label2.backgroundColor = kBlackColor;
    [_tableView addSubview:label2];
    
}

#pragma mark -- UITableViewDelegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = SYSTEMFONT(16);
    cell.textLabel.textColor = KDarkTextColor;
    cell.textLabel.text = @"哈哈哈哈哈啊哈哈";
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UIScrollViewDelegate

//scrollView的方法视图滑动时 实时调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%lf",offset.y);
    //偏移从-200开始
    if (offset.y < -200) {
        bgImageView.mj_y = offset.y;
        bgImageView.mj_h = ABS(offset.y);
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
