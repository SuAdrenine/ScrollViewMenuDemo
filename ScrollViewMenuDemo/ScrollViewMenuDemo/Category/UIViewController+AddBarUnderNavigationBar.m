//
//  UILabel+AddBarUnderNavigationBar.m
//  
//
//  Created by HaoMaiQi-XXR on 16/7/14.
//  Copyright © 2016年 HaoMaiQi. All rights reserved.
//

#import "UIViewController+AddBarUnderNavigationBar.h"
#import <Masonry.h>
#import "XBYBaseScrollViewController.h"

@implementation UIViewController (AddBarUnderNavigationBar)

- (void)addBarWithColor:(UIColor *)color {
    UIView *bar = [UIView new];
    bar.backgroundColor = color;
    [self.view addSubview:bar];
    if ([self isKindOfClass:[XBYBaseScrollViewController class]]) {
        [((XBYBaseScrollViewController *)self) setSubViewToScrollingNavigationBackView:bar];
    }
    
//    bar.frame = CGRectMake(0, 0, kScreenWidth, 64);
    
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.bottom.equalTo(self.mas_topLayoutGuideBottom);
    }];
}

- (void)addCallPhoneRightBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lxdh"] style:UIBarButtonItemStylePlain target:self action:@selector(callPhoneAction)];
}

- (void)addMsgCenterRightBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"无消息"] style:UIBarButtonItemStylePlain target:self action:@selector(msgCenterAction)];
}

#pragma mark - call phone
- (void)callPhoneAction {
    [[[UIAlertView alloc]initWithTitle:nil message:@"拨打好气网客服电话400-789-8555" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
}

- (void)msgCenterAction {
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 1) {
        
        NSString *urlStr = [NSString stringWithFormat:@"tel:400-789-8555"];
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            
        }
    }
}
@end
