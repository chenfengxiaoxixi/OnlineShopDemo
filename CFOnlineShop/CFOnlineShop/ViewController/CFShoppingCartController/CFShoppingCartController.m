//
//  CFShoppingCartController.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/18.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFShoppingCartController.h"
#import "CFShoppingCartCell1.h"
#import "CFShoppingCartCell2.h"
#import "CFShoppingCartHeaderView.h"

@interface CFShoppingCartController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CFShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"购物车"];
    self.navigationView.backgroundColor = kWhiteColor;
    [self setCollectionView];
    
}

- (void)setCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TabbarHeight - TopHeight) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kClearColor;
    [_collectionView registerClass:[CFShoppingCartCell1 class] forCellWithReuseIdentifier:@"CollectionCell"];
    [_collectionView registerClass:[CFShoppingCartCell2 class] forCellWithReuseIdentifier:@"CollectionCell2"];
    [_collectionView registerClass:[CFShoppingCartHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:_collectionView];
    
    //去掉顶部偏移
    if (@available(iOS 11.0, *))
    {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *collectionCell = @"CollectionCell";
        CFShoppingCartCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
        [cell configCollectionCellType:(CFEditCollectionCellTypeWithDelete)];
        
        //cell.backgroundColor = kRedColor;
        cell.titleStr.text = @"测试商品";
        NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
        cell.imageView.image = [UIImage imageNamed:imageName];
        [cell setDeleteButtonAction:^(UIButton *button) {
            NSLog(@"删除操作");
        }];
        
        return cell;
    }
    else
    {
        static NSString *collectionCell2 = @"CollectionCell2";
        CFShoppingCartCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell2 forIndexPath:indexPath];
        [cell configCollectionCellType:(CFEditCollectionCellTypeWithNone)];
        cell.backgroundColor = kRedColor;
        cell.titleStr.text = @"测试商品";
        
        NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
        
        cell.imageView.image = [UIImage imageNamed:imageName];
        [cell setDeleteButtonAction:^(UIButton *button) {
            NSLog(@"删除操作");
        }];
        
        return cell;
    }
}


#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return CGSizeMake(_collectionView.mj_w - 10, 80);
    }
    else
    {
        NSInteger itemCount = 2;
        return CGSizeMake((Main_Screen_Width - 25)/itemCount, (Main_Screen_Width - 25)/itemCount + 60);
    }
}

//距离collectionview的上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,10,0,10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 1){
        
        CFShoppingCartHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableview = headerView;
        //reusableview.backgroundColor = kRedColor;
    }
    
    return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    
    return CGSizeMake(Main_Screen_Width, 40);
}

#pragma mark --UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click collectionView row");
}

#pragma mark --UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖动");
    [[_collectionView visibleCells] makeObjectsPerformSelector:@selector(hiddenButtonsWithAnimation)];
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
