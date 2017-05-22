//
//  AFNetworkingManager.h
//  BaoDongHua
//
//  Created by shen on 16/12/15.
//  Copyright © 2016年 shen. All rights reserved.
//

//#import <Foundation/Foundation.h>
//
//typedef void(^SuccessBlock)(id data);
//typedef void(^FailureBlock)(NSString *error);
//
//@interface AFNetworkingManager : NSObject
//
//+ (void)sendGetNetWork:(NSString *)urlStr dict:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
//
//@end



#import <Foundation/Foundation.h>

@class AFNetworkingManager;

typedef void(^SuccessBlock)(id data);
typedef void(^FailureBlock)(NSString *error);

@interface AFNetworkingManager : NSObject

//单例模式
+ (AFNetworkingManager *)manager;

/**
 *  GET请求
 *
 *  @param url       NSString 请求url
 *  @param paramters NSDictionary 参数
 *  @param success   void(^Success)(id json)回调
 *  @param failure   void(^Failure)(NSError *error)回调
 */
- (void)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramters successBlock:(SuccessBlock)success failureBlock:(FailureBlock)failure;


@end

