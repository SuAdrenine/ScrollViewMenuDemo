//
//  UIViewController+ActivityIndicatorView.h
//  TransportPlatform
//
//  Created by HaoMaiQi-XXR on 16/5/25.
//  Copyright © 2016年 HaoMaiQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIActivityIndicatorView+AFNetworking.h>

@interface UIViewController (ActivityIndicatorView)

@property UIActivityIndicatorView *tp_activityView;
@property (nonatomic, assign) NSInteger animationCount;

- (void)startAnimation;

- (void)endAnimation;

/**
 设置中心点的偏移量Y

 @param offsetY 偏移量Y
 */
- (void)setActivityViewCenterOffsetY:(CGFloat)offsetY;

- (BOOL)isAnimating;

@end
