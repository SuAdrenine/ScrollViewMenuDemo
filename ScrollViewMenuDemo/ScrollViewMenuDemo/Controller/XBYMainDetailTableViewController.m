//
//  XBYMainDetailTableViewController.m
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/20.
//  Copyright © 2017年 xby. All rights reserved.
//

#import "XBYMainDetailTableViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <Masonry.h>

@interface XBYMainDetailTableViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation XBYMainDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
    NSURL *url = [NSURL URLWithString:self.item.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIWebView *)webView {
    if (!_webView) {
        _webView = [UIWebView new];
    }
    
    return _webView;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
