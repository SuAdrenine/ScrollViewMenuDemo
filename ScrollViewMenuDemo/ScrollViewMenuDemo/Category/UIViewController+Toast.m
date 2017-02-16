//
//  UIViewController+Toast.m
//  TransportPlatform
//
//  Created by HaoMaiQi-XXR on 16/5/26.
//  Copyright © 2016年 HaoMaiQi. All rights reserved.
//

#import "UIViewController+Toast.h"
#import <MBProgressHUD.h>
#import <objc/runtime.h>


@interface UIViewController ()

@property (nonatomic,assign) BOOL toastIsShowing;
@property (nonatomic, strong) NSTimer *toastTimer;
@end

@implementation UIViewController (Toast)

//不居中
- (void)showMBProcessHUDWithText:(NSString *)text{
    if (self.toastIsShowing) {
        return;
    }
//    显示提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:CalcFont(14.5)];
    hud.margin = 10.f;
    hud.color = [UIColor colorWithRed:0x00/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:0.7];
//    hud.yOffset = kScreenHeight/2.0 - CalcHeight(100);
//    hud.yOffset = 50;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
    self.toastTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(toastTimerAction) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.toastTimer forMode:NSRunLoopCommonModes];
    self.toastIsShowing = YES;
}

static BOOL windowToastIsShowing = NO;
+ (void)showMBProcessHUDInWindowWithText:(NSString *)text {
    if (windowToastIsShowing) {
        return;
    }
    
    //    显示提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:CalcFont(14.5)];
    hud.margin = 10.f;
    hud.color = [UIColor colorWithRed:0x00/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:0.7];
    //    hud.yOffset = kScreenHeight/2.0 - CalcHeight(100);
//    hud.yOffset = 50;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
    windowToastIsShowing = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        windowToastIsShowing = NO;
    });
}

- (void)toastTimerAction {
    [self.toastTimer invalidate];
    self.toastTimer = nil;
    self.toastIsShowing = NO;
}

#pragma mark - getter
- (BOOL)toastIsShowing {
    return  [objc_getAssociatedObject(self, @selector(toastIsShowing))boolValue];
}
- (void)setToastIsShowing:(BOOL)toastIsShowing {
    objc_setAssociatedObject(self, @selector(toastIsShowing), @(toastIsShowing), OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimer *)toastTimer {
    return  objc_getAssociatedObject(self, @selector(toastTimer));
}
- (void)setToastTimer:(NSTimer *)toastTimer {
    objc_setAssociatedObject(self, @selector(toastTimer), toastTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
