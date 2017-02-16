//
//  XBYBaseScrollViewController.m
//  
//
//  Created by HaoMaiQi-XXR on 16/7/14.
//  Copyright © 2016年 HaoMaiQi. All rights reserved.
//

#import "XBYBaseScrollViewController.h"
#import <Masonry.h>

@interface XBYBaseScrollViewController ()<UIScrollViewDelegate>

@end

@implementation XBYBaseScrollViewController {
    UIView *scrollingNavigationBackView;
}

- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.delaysContentTouches = NO;
    scrollView.delegate = self;
    self.view = scrollView;
    
    UIView *contentView = [UIView new];
    [scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(scrollView);
        make.width.mas_equalTo(@(kScreenWidth));
        make.height.greaterThanOrEqualTo(scrollView).offset(1).priorityHigh();
//        make.bottom.equalTo(scrollView).priorityLow();
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    在注册完成界面  弹出选择器会有问题， 需要加上下面的代码
    if (scrollingNavigationBackView ) {
        [self resetNavigationBack:scrollingNavigationBackView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLayoutSubviews {
    CGSize contentSize = ((UIScrollView *)(self.view)).contentSize;
    CGFloat minScrollHeight = self.view.frame.size.height + 1 - ((UIScrollView *)(self.view)).contentInset.top - ((UIScrollView *)(self.view)).contentInset.bottom;
    if (contentSize.height < minScrollHeight) {
        contentSize.height = minScrollHeight;
        ((UIScrollView *)(self.view)).contentSize = CGSizeMake(kScreenWidth, minScrollHeight);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollingNavigationBackView) {
        [self bringSubViewToNavigationBack:scrollingNavigationBackView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollingNavigationBackView ) {
        [self resetNavigationBack:scrollingNavigationBackView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollingNavigationBackView ) {
        [self resetNavigationBack:scrollingNavigationBackView];
    }
}

#pragma mark - public method
//在scrollview滑动时，subview会自动倍加入到uinavigationBar（隐藏subView应该也行）
- (void)setSubViewToScrollingNavigationBackView:(UIView *)subView {
    scrollingNavigationBackView = subView;
}

#pragma mark - private method
//将self的subview加入navigationBar的下面， uiscrollview滑动的时候就不会看到这个subview
- (void)bringSubViewToNavigationBack:(UIView *)subView {
    if ([self.navigationController.navigationBar.subviews containsObject:subView]) {
        return;
    }
    [subView removeFromSuperview];
    subView.frame = CGRectMake(0, -20, CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
    [self.navigationController.navigationBar insertSubview:subView atIndex:0];
}

//恢复subview到self.view
- (void)resetNavigationBack:(UIView *)subView {
    if ([self.view.subviews containsObject:subView]) {
        return;
    }
    [subView removeFromSuperview];
    subView.frame = CGRectMake(0, 0, CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
    [self.view addSubview:subView];
}
@end
