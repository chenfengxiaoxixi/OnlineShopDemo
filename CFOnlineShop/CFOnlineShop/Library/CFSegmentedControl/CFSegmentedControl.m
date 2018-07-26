//
//  CFSegmentedControl.m
//  CFOnlineShop
//
//  Created by chenfeng on 2018/7/20.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CFSegmentedControl.h"

#define bottomLineEdge 15

@interface CFSegmentedControl ()

@property (nonatomic, assign) NSInteger numOfMenu;

@property (nonatomic, assign) NSInteger tapIndex;
//layers array
@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) NSArray *bgLayers;
@property (nonatomic, strong) UIView *bottomLine;//底部滑动横线

@end

@implementation CFSegmentedControl

#pragma mark - setter
- (void)setDataSource:(id<CFSegmentedControlDataSource>)dataSource {
    
    _dataSource = dataSource;
    
    //configure view
    if ([_dataSource respondsToSelector:@selector(getSegmentedControlTitles)]) {
        _numOfMenu = [[_dataSource getSegmentedControlTitles] count];
    } else {
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++) {
        //背景
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:kClearColor andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        NSString *titleString = [_dataSource getSegmentedControlTitles][i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:KDarkTextColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        
    }
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(bottomLineEdge, self.mj_h - 4, self.mj_w/_numOfMenu - bottomLineEdge*2, 4)];
    _bottomLine.backgroundColor = kOrangeColor;
    _bottomLine.layer.cornerRadius = 2;
    [self addSubview:_bottomLine];
    
    _titles = [tempTitles copy];
    _bgLayers = [tempBgLayers copy];
}

#pragma mark - init method

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string font:SYSTEMFONT(16)];
    
    CATextLayer *layer = [[CATextLayer alloc] init];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    layer.fontSize = 16;
    
    //    UIFont *font = BOLDSYSTEMFONT(14);
    //    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    //    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
    //    layer.font = fontRef;
    //    layer.fontSize = font.pointSize;
    //    CGFontRelease(fontRef);
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string font:(UIFont *)font
{
    NSDictionary *dic = @{NSFontAttributeName: font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}


- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    
    if (_numOfMenu == 0) {
        return;
    }
    
    _tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    if (paramSender == nil) {
        _tapIndex = 0;
    }
    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != _tapIndex) {
            [self animateTitle:_titles[i] isSelect:NO complete:^{

            }];
        }
    }
    
    WeakSelf(self);
    [self animateBottomLinePosition:_bottomLine complete:^{
        [self animateTitle:weakself.titles[weakself.tapIndex] isSelect:YES complete:^{
            
        }];
    }];
    
    if ([_delegate respondsToSelector:@selector(control:didSelectAtIndex:)])
    {
        [_delegate control:self didSelectAtIndex:_tapIndex];
    }
    
}

/**
 *动画左右移动底部横线
 */
- (void)animateBottomLinePosition:(UIView *)bottomLine complete:(void(^)(void))complete
{
    if (_numOfMenu == 0) {
        return;
    }
    
    //bottomLine.hidden = !show;
    WeakSelf(self);
    [UIView animateWithDuration:0.3 animations:^{
        bottomLine.mj_x = bottomLineEdge + (self.frame.size.width / weakself.numOfMenu) * weakself.tapIndex;
    }];
    
    complete();
}

/**
 *字体颜色改变
 */
- (void)animateTitle:(CATextLayer *)title isSelect:(BOOL)isSelect complete:(void(^)(void))complete {
    
    if (_numOfMenu == 0) {
        return;
    }
    
    CGSize size = [self calculateTitleSizeWithString:title.string font:SYSTEMFONT(16)];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    if (isSelect) {
        title.foregroundColor = kOrangeColor.CGColor;
    }
    else
    {
        title.foregroundColor = KDarkTextColor.CGColor;
    }
    
    complete();
}

- (void)didSelectIndex:(NSInteger )index
{
    _tapIndex = index;
    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != _tapIndex) {
            [self animateTitle:_titles[i] isSelect:NO complete:^{
                
            }];
        }
    }
    
    WeakSelf(self);
    [self animateBottomLinePosition:_bottomLine complete:^{
        [self animateTitle:weakself.titles[weakself.tapIndex] isSelect:YES complete:^{
            
        }];
    }];
    
    if ([_delegate respondsToSelector:@selector(control:didSelectAtIndex:)])
    {
        [_delegate control:self didSelectAtIndex:_tapIndex];
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
