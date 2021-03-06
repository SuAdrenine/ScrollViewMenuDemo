//
//  XBYMainTableViewController.m
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/15.
//  Copyright © 2017年 xby. All rights reserved.
//

#import "XBYMainTableViewController.h"
#import <Masonry.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import "TPHttpManager.h"
#import <MJExtension.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "XBYDataModel.h"
#import "XBYMainTableViewCell.h"
#import "XBYMainDetailTableViewController.h"

@interface XBYMainTableViewController ()<UITableViewDelegate, UITableViewDataSource,XBYBaseTableViewDelegate,XBYMainCellDelegate,UIAlertViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation XBYMainTableViewController {
    XBYDataModel *_currentOrderItem;
    NSDictionary *_currentParams;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBackgroundColor;
    
    [self addSubViews];
    
    [self loadData];
    
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)addSubViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
        make.top.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

static NSString *cellClassStr = @"XBYMainTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[cellClassStr stringByAppendingString:_tabKey]];
    if (!cell) {
        cell = [[NSClassFromString(cellClassStr) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[cellClassStr stringByAppendingString:_tabKey]];
    }
    [self configureCell:cell indexPath:indexPath];
    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:[cellClassStr stringByAppendingString:_tabKey] cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell indexPath:indexPath];
    }];
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBYDataModel *item = self.dataArr[indexPath.row];
    _currentOrderItem = item;
    
    XBYMainDetailTableViewController *orderDetailVC = [XBYMainDetailTableViewController new];
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    orderDetailVC.item = item;
    orderDetailVC.delegate = self;
    [self.parentViewController.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - XBYRefreshTableViewDelegate
- (void)refreshTableView:(XBYBaseTableView *)tableView loadNewDataWithPage:(NSInteger)page {
    [self loadDataWithNeedResetDataArr:YES showActivity:NO];
}

- (void)refreshTableView:(XBYBaseTableView *)tableView loadMoreDataWithPage:(NSInteger)page {
    [self loadDataWithNeedResetDataArr:NO showActivity:NO];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_data_icon"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    if (_queryParams.length) {
        text = @"抱歉，未找到您搜索的结果";
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -25;
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    //要先endAnimation 再reloadData  不然不会显示空数据页面
    return !([self isAnimating]|| [((XBYBaseTableView *)scrollView)isLoadingData]);
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - private method
- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    XBYDataModel *item = self.dataArr[indexPath.row];
    ((XBYMainTableViewCell *)cell).item = item;
    ((XBYMainTableViewCell *)cell).delegate = self;
}

- (void)endTableViewRefreshing {
    self.tableView.totalSize = self.tableView.totalSize + 1;
}

- (void)loadData {
    [self loadDataWithNeedResetDataArr:YES showActivity:YES];
}


/**
 加载数据列表
 
 @param needResetDataArr 是否重置tableView的page
 @param showActivity 是否显示加载圈
 */
- (void)loadDataWithNeedResetDataArr:(BOOL)needResetDataArr showActivity:(BOOL)showActivity {
    if (needResetDataArr) {
        self.dataArr = @[].mutableCopy;
        [self.tableView reloadData];
        
        [self.tableView resetPage];
    }
    self.tableView.totalSize = 50;
    NSNumber *myPageNums = [[NSNumber alloc ] initWithInteger:self.tableView.pageSize];
    
    NSDictionary *params = @{@"key":@"353eedb9ddb49d8b758523f8251d1ea1",
                             @"num": myPageNums};
    
    [self startAnimation];
    TPGET(fullHttpUrl(_tabKey), params, ^(NSURLSessionDataTask *task, id responseObject, BOOL suc) {
        
        NSLog(@"responseObject :%@",responseObject);
        if (suc) {
            NSMutableArray *array = [NSMutableArray array];
            NSLog(@"responseObject :%@",responseObject);
            
            array = responseObject[@"newslist"];
            NSDictionary *dic = [NSDictionary dictionary];
            for (int i=0;i<[array count];i++) {
                dic = array[i];
                XBYDataModel *model = [XBYDataModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            [self.tableView reloadData];
            [self endAnimation];
            [self endTableViewRefreshing];
        } else {
            NSLog(@"error ---- error");
            [self.tableView pageDecreaseOne];
            [self endTableViewRefreshing];
            [self endAnimation];
            
            
        }
        
    }, ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error--->%@",error);
        [self.tableView pageDecreaseOne];
        [self endTableViewRefreshing];
        [self endAnimation];
    });
}

#pragma mark - getter
- (XBYBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XBYBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.pageAddOne = NO;
        _tableView.backgroundColor = ColorFromRGB(0xeeeeee);
        [_tableView registerClass:NSClassFromString(cellClassStr) forCellReuseIdentifier:[cellClassStr stringByAppendingString:_tabKey]];
        _tableView.refreshDelegate = self;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.1;
        _tableView.sectionHeaderHeight = 0.1;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        //        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
#pragma mrk - XBYMainCellDelegate
-(void)orderCell:(id)cellView didClickBtnWithBtnTitle:(NSString *)title params:(NSDictionary *)params {
    NSLog(@"你可能点了一个假的Button");
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSUInteger tag = alertView.tag;
        if (tag == 1001) {
            
        } else if (tag == 1002) {
            
        }
    }
}
@end
