//
//  XBYBaseTableView.m
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/15.
//  Copyright © 2017年 xby. All rights reserved.
//

#import "XBYBaseTableView.h"

@implementation XBYBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _from = 0;
        _pageSize = 15;
        _pageAddOne = YES;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        self.mj_header.automaticallyChangeAlpha = YES;
        ((MJRefreshNormalHeader *)self.mj_header).lastUpdatedTimeLabel.hidden = YES;
        self.mj_footer.automaticallyChangeAlpha = YES;
    }
    return self;
}

#pragma mark - setter
- (void)setTotalSize:(NSInteger)totalSize {
    _totalSize = totalSize;
    
    NSInteger dataCount = [self dataCount];
    
    if ([self.mj_footer isRefreshing]) {
        if (dataCount < _totalSize) {
            [self.mj_footer endRefreshing];
        }
        
    } else if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
        
    }
    
    if (dataCount >= _totalSize) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefreshing {
    self.totalSize = self.totalSize;
}

- (void)pageDecreaseOne {
    if (self.isPageAddOne) {
        if (self.page > self.from) {
            self.page--;
        }
    } else {
        if (self.page > self.from) {
            self.page -= self.pageSize;
        }
    }
}

- (void)resetPage {
    self.page = self.from;
}

- (BOOL)isLoadingData {
    return self.mj_header.isRefreshing || self.mj_footer.isRefreshing;
}

//重写getter方法 目的是主动删除掉一些数据时下次请求下（pageCount - dataCount）条数据
#pragma mark - getter
- (NSInteger)page {
    NSInteger dataCount = [self dataCount];
    NSInteger pageCount = _pageAddOne ? _page * _pageSize : _page;
    if (dataCount < pageCount) {
        return dataCount;
    } else {
        return _page;
    }
}

- (NSInteger)pageSize {
    NSInteger dataCount = [self dataCount];
    NSInteger pageCount = _pageAddOne ? _page * _pageSize : _page;
    if (dataCount < pageCount) {
        return pageCount - dataCount;
    } else {
        return _pageSize;
    }
}

#pragma mark - private method
- (NSInteger)dataCount {
    NSInteger sectionCount = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sectionCount = [self.dataSource numberOfSectionsInTableView:self];
    }
    NSInteger sum = 0;
    for (int i = 0; i < sectionCount; i++) {
        sum += [self.dataSource tableView:self numberOfRowsInSection:i];
    }
    return sum;
}

#pragma mark - target selectori
- (void)loadNewData {
    [self resetPage];
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:loadNewDataWithPage:)]) {
        [self.refreshDelegate refreshTableView:self loadNewDataWithPage:self.page];
    }
}

- (void)loadMoreData {
    
    if (self.isPageAddOne) {
        self.page++;
    } else {
        self.page += self.pageSize;
    }
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:loadMoreDataWithPage:)]) {
        [self.refreshDelegate refreshTableView:self loadMoreDataWithPage:self.page];
    }
}
@end
