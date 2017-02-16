//
//  XBYViewController.m
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/15.
//  Copyright © 2017年 xby. All rights reserved.
//

#import "XBYViewController.h"
#import "XBYMainTableViewController.h"
#import "XBYLabel.h"
#import <Masonry.h>
#import "UIViewController+AddBarUnderNavigationBar.h"

@interface XBYViewController ()<UIScrollViewDelegate,XBYMainTableViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *smallScrollView;

@property (nonatomic, strong) UIScrollView *bigScrollView;

@property (nonatomic, strong) NSArray *orderStatusArr;

@end

@implementation XBYViewController {
    CGFloat smallScrollViewH;
    XBYMainTableViewController *needScrollToTopPage;
    NSMutableArray *childVcs;
    NSInteger _currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"滑动菜单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kViewBackgroundColor;
    
    smallScrollViewH = 44;
    
    [self.view addSubview:self.smallScrollView];
    [self.view addSubview:self.bigScrollView];
    [self setLayouts];
    
    [self addControllers];
    
    [self setupSmallScrollView];
    [self setupBigScrollView];
    
    [self setDefaultController];
}

- (void)setLayouts {
    //    [self.smallScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.view);
    //        make.top.equalTo(self.mas_topLayoutGuideBottom);
    //        make.height.mas_equalTo(@(smallScrollViewH));
    //    }];
    //
    //    [self.bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.left.bottom.equalTo(self.view);
    //        make.top.equalTo(self.smallScrollView.mas_bottom);
    //    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.frame = CGRectMake(0, 64, kScreenWidth, smallScrollViewH);
    self.bigScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.smallScrollView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.smallScrollView.frame));
}

#pragma mark - public method
- (void)refreshControllerAtIndex:(NSInteger)index {
    XBYMainTableViewController *vc = childVcs[index];
    
    //要判断有没有数据，没数据的时候（可能还没有调用viewDidLoad？）计算不出cell的高度？
    if (!vc.dataArr.count) {
        return;
    }
    
    [vc loadData];
}

- (void)refreshCurrentController {
    [self refreshControllerAtIndex:_currentIndex];
}

#pragma mark - private method
- (void)addControllers {
    childVcs = @[].mutableCopy;
    for (int i = 0; i < self.orderStatusArr.count; i++) {
        XBYMainTableViewController *orderVC = [[XBYMainTableViewController alloc]init];
        orderVC.tabKey = self.orderStatusArr[i][@"tabKey"];
        orderVC.delegate = self;
        [childVcs addObject:orderVC];
    }
}

- (void)setupSmallScrollView {
    CGFloat labelW = kScreenWidth/(self.orderStatusArr.count>5?5:self.orderStatusArr.count);
    self.smallScrollView.contentSize = CGSizeMake(labelW * self.orderStatusArr.count, 44);
    
    CGFloat labelX,labelY = 0, labelH = smallScrollViewH;
    for (int i = 0; i < self.orderStatusArr.count; i++) {
        labelX = i * labelW;
        XBYLabel *label = [[XBYLabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = self.orderStatusArr[i][@"name"];
        label.tag = i;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction:)]];
        [self.smallScrollView addSubview:label];
    }
}

- (void)setupBigScrollView {
    self.bigScrollView.contentSize = CGSizeMake(self.orderStatusArr.count * self.view.frame.size.width, 0);
    NSLog(@"");
}

- (void)setDefaultController {
    // 添加默认控制器
    XBYMainTableViewController *vc = [childVcs firstObject];
    [self addChildViewController:vc];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    XBYLabel *lable = [self.smallScrollView.subviews firstObject];
    lable.scale = 1.0;
    needScrollToTopPage = vc;
}

#pragma mark - ScrollToTop
- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    needScrollToTopPage.tableView.scrollsToTop = NO;
    needScrollToTopPage = childVcs[index];
    needScrollToTopPage.tableView.scrollsToTop = YES;
}

#pragma mark - UIScrollViewDelegate
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    // 滚动标题栏
    XBYLabel *titleLable = (XBYLabel *)self.smallScrollView.subviews[index];
    //    label居中的offsetx
    CGFloat offsetx = titleLable.center.x - self.smallScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);
    //  要放在gcd里才有动画,??????
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.smallScrollView setContentOffset:offset animated:YES];
    });
    
    XBYMainTableViewController *newsVc = childVcs[index];
    _currentIndex = index;
    //其他label设置成初始状态
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            XBYLabel *temlabel = self.smallScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    [self setScrollToTopWithTableViewIndex:index];
    
    if (newsVc.view.superview) return;
    
    [self addChildViewController:newsVc];
    newsVc.view.frame = scrollView.bounds;//bounds的x就是scrollView的offsetx
    [self.bigScrollView addSubview:newsVc.view];
    [newsVc didMoveToParentViewController:self];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;//取整代表左边那个label 不管是哪个方向都是
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    XBYLabel *labelLeft = self.smallScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScrollView.subviews.count) {
        XBYLabel *labelRight = self.smallScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}

#pragma mark - gesture selector
- (void)labelTapAction:(UITapGestureRecognizer *)gesture {
    XBYLabel *titlelable = (XBYLabel *)gesture.view;
    
    CGFloat offsetX = titlelable.tag * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    [self setScrollToTopWithTableViewIndex:titlelable.tag];
}

#pragma mark - getter
- (UIScrollView *)smallScrollView {
    if (!_smallScrollView) {
        _smallScrollView = [UIScrollView new];
        _smallScrollView.backgroundColor = [UIColor whiteColor];
        _smallScrollView.showsVerticalScrollIndicator = NO;
        _smallScrollView.showsHorizontalScrollIndicator = NO;
        _smallScrollView.scrollsToTop = NO;
        //        _smallScrollView.layer.borderColor = ColorFromRGB(0xeeeeee).CGColor;
        //        _smallScrollView.layer.borderWidth = kSeperatorLineHeight;
    }
    return _smallScrollView;
}

- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        _bigScrollView = [UIScrollView new];
        _bigScrollView.showsHorizontalScrollIndicator = NO;
        _bigScrollView.scrollsToTop = NO;
        _bigScrollView.pagingEnabled = YES;
        _bigScrollView.delegate = self;
    }
    return _bigScrollView;
}

- (NSArray *)orderStatusArr {
    if (!_orderStatusArr) {
        _orderStatusArr = @[@{@"name":@"推荐",@"tabKey":@"01"},
                            @{@"name":@"美女",@"tabKey":@"02"},
                            @{@"name":@"汽车",@"tabKey":@"03"},
                            @{@"name":@"科技",@"tabKey":@"04"},
                            @{@"name":@"军事",@"tabKey":@"05"},
                            @{@"name":@"笑话",@"tabKey":@"06"},
                            @{@"name":@"视频",@"tabKey":@"07"},
                            @{@"name":@"生活",@"tabKey":@"08"},
                            ];
    }
    return _orderStatusArr;
}
@end

