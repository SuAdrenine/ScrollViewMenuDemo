//
//  XBYBaseTableView.h
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/15.
//  Copyright © 2017年 xby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@class XBYBaseTableView;
@protocol XBYBaseTableViewDelegate <NSObject>

- (void)refreshTableView:(XBYBaseTableView *)tableView loadNewDataWithPage:(NSInteger)page;
- (void)refreshTableView:(XBYBaseTableView *)tableView loadMoreDataWithPage:(NSInteger)page;

@end

@interface XBYBaseTableView : UITableView


/**
 page每次是否递增1 默认是YES
 */
@property (nonatomic, assign, getter=isPageAddOne) BOOL pageAddOne;

/**
 第一页的页码 默认是0
 */
@property (nonatomic, assign) NSInteger from;

/**
 当前页页码
 */
@property (nonatomic, assign) NSInteger page;

/**
 每页的条数
 */
@property (nonatomic, assign) NSInteger pageSize;

/**
 总数据条数 在setter里会停止刷新
 */
@property (nonatomic, assign) NSInteger totalSize;


@property (nonatomic, weak) id<XBYBaseTableViewDelegate> refreshDelegate;

- (void)endRefreshing;


/**
 page设置为from
 */
- (void)resetPage;


/**
 page恢复为上一页
 */
- (void)pageDecreaseOne;

- (BOOL)isLoadingData;
@end

