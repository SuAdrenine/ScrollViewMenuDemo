//
//  UIViewController+ActivityIndicatorView.m
//  TransportPlatform
//
//  Created by HaoMaiQi-XXR on 16/5/25.
//  Copyright © 2016年 HaoMaiQi. All rights reserved.
//

#import "UIViewController+ActivityIndicatorView.h"
#import <objc/runtime.h>
#import <Masonry.h>

@interface UIActivityIndicatorView (UserInteractionDisabled)

@end

@implementation UIActivityIndicatorView (UserInteractionDisabled)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(startAnimating);
        SEL swizzledSelector = @selector(tp_startAnimating);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        SEL originalSelector1 = @selector(stopAnimating);
        SEL swizzledSelector1 = @selector(tp_stopAnimating);
        
        Method originalMethod1 = class_getInstanceMethod(class, originalSelector1);
        Method swizzledMethod1 = class_getInstanceMethod(class, swizzledSelector1);
        
        BOOL success1 = class_addMethod(class, originalSelector1, method_getImplementation(swizzledMethod1), method_getTypeEncoding(swizzledMethod1));
        if (success1) {
            class_replaceMethod(class, swizzledSelector1, method_getImplementation(originalMethod1), method_getTypeEncoding(originalMethod1));
        } else {
            method_exchangeImplementations(originalMethod1, swizzledMethod1);
        }
    });
}

- (void)tp_startAnimating {
    [self tp_startAnimating];
    
    UIView *superView = [self superview];
    if (superView) {
        superView.userInteractionEnabled = NO;
    }
}

- (void)tp_stopAnimating {
    [self tp_stopAnimating];
    
    UIView *superView = [self superview];
    if (superView) {
        superView.userInteractionEnabled = YES;
    }
}
@end


@implementation UIViewController (ActivityIndicatorView)


- (void)startAnimation {
    self.animationCount++;
    [self.tp_activityView startAnimating];
}

- (void)endAnimation {
    if (self.animationCount <= 0) {
        return;
    }
    
    self.animationCount--;
    if (!self.animationCount) {
        [self.tp_activityView stopAnimating];
    }
}

- (void)setActivityViewCenterOffsetY:(CGFloat)offsetY {
    CGPoint center = self.tp_activityView.center;
    center.y = offsetY;
    self.tp_activityView.center = center;
}

- (BOOL)isAnimating {
    BOOL isAnimating = self.tp_activityView.isAnimating;
    return isAnimating;
}

#pragma mark - getter
- (UIActivityIndicatorView *)tp_activityView
{
    UIActivityIndicatorView *activityView = objc_getAssociatedObject(self, @selector(tp_activityView));
    if (!activityView) {
        activityView = [[UIActivityIndicatorView alloc] init];
        activityView.hidesWhenStopped = YES;
        self.tp_activityView = activityView;
        activityView.layer.zPosition = 1000;
        
        activityView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
        CGRect frame = activityView.frame;
        frame.size = CGSizeMake(80, 80);
        [activityView setFrame:frame];
        
        CGPoint center = self.view.center;
        if (self.navigationController.navigationBarHidden == NO) {
            center.y -= 32;
        }
        
//        UIViewController *vc = self;
//        while (vc.parentViewController) {
//            vc = vc.parentViewController;
//        }
//        center = vc.view.center;
        
        center = [self.view convertPoint:center fromView:self.view.window];
        activityView.center = center;
        activityView.layer.cornerRadius = 6;
        activityView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
        
        [self.view addSubview:activityView];
        
    }
    return activityView;
}

static char animationCountKey;
- (NSInteger)animationCount {
    return [objc_getAssociatedObject(self, &animationCountKey)integerValue];
}

#pragma mark - setter
- (void)setTp_activityView:(UIActivityIndicatorView *)activityView {
    objc_setAssociatedObject(self, @selector(tp_activityView), activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAnimationCount:(NSInteger)animationCount {
    objc_setAssociatedObject(self, &animationCountKey, @(animationCount), OBJC_ASSOCIATION_ASSIGN);
}

//- (void)dealloc {
//    self.tp_activityView = nil;
//}
@end
