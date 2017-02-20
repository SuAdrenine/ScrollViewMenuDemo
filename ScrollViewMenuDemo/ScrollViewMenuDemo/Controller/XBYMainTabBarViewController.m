//
//  XBYMainTabBarViewController.m
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/20.
//  Copyright © 2017年 xby. All rights reserved.
//

#import "XBYMainTabBarViewController.h"
#import "XBYMainViewController.h"
#import "XBYSecondViewController.h"
#import "XBYThirdViewController.h"
#import "XBYFourViewController.h"
#import <UIImage+YYAdd.h>

@interface XBYMainTabBarViewController ()<UITabBarControllerDelegate> {
    NSInteger lastSelectedIndex;

}

@end

@implementation XBYMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lastSelectedIndex = -1;
    
    CGSize imageSize = CGSizeMake(26, 26);
    XBYMainViewController *mainVC = [XBYMainViewController new];
    mainVC.title = @"首页";
    UITabBarItem *mainTabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"首页"] imageByResizeToSize:imageSize] tag:100];
    mainVC.tabBarItem = mainTabBarItem;
    
    XBYSecondViewController *yuleVC = [XBYSecondViewController new];
    yuleVC.title = @"娱乐";
    UITabBarItem *yuleTabBarItem = [[UITabBarItem alloc] initWithTitle:@"娱乐" image:[[UIImage imageNamed:@"娱乐"] imageByResizeToSize:imageSize] tag:100];
    yuleVC.tabBarItem = yuleTabBarItem;
    
    //设置shoucangVC.view.backgroundColor就会触发它的viewDidLoad方法
    XBYThirdViewController *shoucangVC = [XBYThirdViewController new];
    shoucangVC.title = @"收藏";
    UITabBarItem *shoucangTabBarItem = [[UITabBarItem alloc] initWithTitle:@"收藏" image:[[UIImage imageNamed:@"收藏"] imageByResizeToSize:imageSize] tag:100];
    shoucangVC.tabBarItem = shoucangTabBarItem;
    
    XBYFourViewController *mineVC = [XBYFourViewController new];
    mineVC.title = @"我的";
    UITabBarItem *mineTabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"我的"] imageByResizeToSize:imageSize] tag:100];
    mineVC.tabBarItem = mineTabBarItem;
    
    NSArray *viewControllers = @[[self navigationControllerWithController:mainVC],
                                 [self navigationControllerWithController:yuleVC],
                                 [self navigationControllerWithController:shoucangVC],
                                 [self navigationControllerWithController:mineVC]];
    self.viewControllers = viewControllers;
    
    self.delegate = self;
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (UINavigationController *)navigationControllerWithController:(UIViewController *)vc {
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    //    ios 8属性  swipe时自动隐藏navigationBar
    //    nav.hidesBarsOnSwipe = YES;
    nav.view.backgroundColor = [UIColor whiteColor];
    return nav;
}

#pragma mark -
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSInteger selectedIndex = [self.viewControllers indexOfObject:viewController];
    
    lastSelectedIndex = selectedIndex;
    if (selectedIndex == 3 || selectedIndex == 2) {
        
    }
    return YES;
}

@end
