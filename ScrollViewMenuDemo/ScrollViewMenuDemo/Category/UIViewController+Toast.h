//
//  UIViewController+Toast.h
//  TransportPlatform
//
//  Created by HaoMaiQi-XXR on 16/5/26.
//  Copyright © 2016年 HaoMaiQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Toast)
- (void)showMBProcessHUDWithText:(NSString *)text;

+ (void)showMBProcessHUDInWindowWithText:(NSString *)text;
@end
