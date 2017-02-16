//
//  XBYMainTableViewController.h
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/15.
//  Copyright © 2017年 xby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBYBaseTableView.h"

@class XBYMainTableViewController;
@protocol XBYMainTableViewControllerDelegate <NSObject>

/**
 操作成功的代理方法
 
 @param ovc 订单控制器
 @param title 操作按钮的标题
 */
- (void)orderTableViewController:(XBYMainTableViewController *)ovc
didFinishOperateOrderWithBtnTitle:(NSString *)title;

@end

@interface XBYMainTableViewController : UIViewController

@property (nonatomic, strong) XBYBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

/**
 标签栏的key  接口入參要用
 */
@property (nonatomic, strong) NSString *tabKey;

/**
 搜索关键字 接口入參要用
 */
@property (nonatomic, strong) NSString *queryParams;

@property (nonatomic, weak) id<XBYMainTableViewControllerDelegate> delegate;

- (void)loadData;
@end
