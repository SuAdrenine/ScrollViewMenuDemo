//
//  TPHttpManager.h
//  TransportPlatform
//
//  Created by HaoMaiQi-XXR on 16/5/13.
//  Copyright © 2016年 HaoMaiQi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "UIViewController+Toast.h"
#import "UIViewController+ActivityIndicatorView.h"

#define TPREQUEST [TPHttpManager sharedClient]
#define TPTASK NSURLSessionDataTask

/**
 *  服务器有响应时的回调
 *
 *  @warning
 *
 *  @param operation   AF对象
 *  @param object 响应体
 *  @param suc     是否成功，由于在下一层AF的success回调会被截取，当响应体里result字段不为0时，suc为NO，result为0时，suc为YES
 */
typedef void(^DDRequestSuccess)(TPTASK *task,id object,BOOL suc);

/**
 *  服务器连接失败时的回调
 *  @warning
 *
 *  @param operationm AF对象
 *  @param error      AF生成的error
 */
typedef void(^DDRequestFailure)(TPTASK *task,NSError *error);

NSString *fullHttpUrl(NSString *uri);

TPTASK *
TPPOST(NSString *url,
       NSDictionary * param,
       DDRequestSuccess success,
       DDRequestFailure failure);

TPTASK *
TPPOSTBACKGROUND(NSString *url,
                 NSDictionary * param,
                 DDRequestSuccess success,
                 DDRequestFailure failure, BOOL showError, BOOL needDealParam);

TPTASK *
TPPOSTDATA(NSString *url,
           NSDictionary * param,
           NSDictionary * bodyData,
           DDRequestSuccess success,
           DDRequestFailure failure);

TPTASK *
TPGET(NSString *url,
      NSDictionary * param,
      DDRequestSuccess success,
      DDRequestFailure failure);


@interface TPHttpManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
+ (instancetype)sharedClient;

+ (void)updateAppConfigures;

@end
