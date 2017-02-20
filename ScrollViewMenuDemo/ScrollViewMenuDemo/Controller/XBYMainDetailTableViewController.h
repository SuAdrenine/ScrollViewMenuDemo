//
//  XBYMainDetailTableViewController.h
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/20.
//  Copyright © 2017年 xby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBYDataModel.h"

@protocol XBYMainCellDelegate;
@interface XBYMainDetailTableViewController : UIViewController
@property (nonatomic, strong) XBYDataModel *item;

@property (nonatomic, weak) id<XBYMainCellDelegate> delegate;

@end
