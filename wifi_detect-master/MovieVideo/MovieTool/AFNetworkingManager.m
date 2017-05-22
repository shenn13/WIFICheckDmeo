//
//  AFNetworkingManager.m
//  BaoDongHua
//
//  Created by shen on 16/12/15.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "AFNetworkingManager.h"
#import "AFNetworking.h"

static AFNetworkingManager *manager = nil;
static AFHTTPSessionManager *afnManager = nil;
@implementation AFNetworkingManager

+ (AFNetworkingManager *)manager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[AFNetworkingManager alloc] init];
        afnManager = [AFHTTPSessionManager manager];
        afnManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return manager;
}

-(void)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramters successBlock:(SuccessBlock)success failureBlock:(FailureBlock)failure{
    
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES；
        securityPolicy.validatesDomainName = NO;
    
        afnManager.securityPolicy  = securityPolicy;
        afnManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//      NSLog(@"------------------%@",url);
        [afnManager GET:url parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               failure(error.localizedDescription);
        }];
}

@end

