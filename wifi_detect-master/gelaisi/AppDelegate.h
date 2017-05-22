//
//  AppDelegate.h
//  WIFICheck-Dmeo
//
//  Created by shen on 17/3/31.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTSplashAd.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GDTSplashAdDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) GDTSplashAd *splash;

//判断是否下载APP
@property (nonatomic,strong) NSString *yuanFenBaURLSchemesIsOnStr;
@property (nonatomic,strong) NSString *beautyShowURLSchemesIsOnStr;
@property (nonatomic,strong) NSString *qiPaiYouXi0214URLSchemesIsOnStr;
@property (nonatomic,strong) NSString *jiaoYou0214URLSchemesIsOnStr;
//获得积分方式的积分
@property (nonatomic,strong) NSString *appCommentScore;
@property (nonatomic,strong) NSString *appDownLoadScore;
@property (nonatomic,strong) NSString *shareScore;
@property (nonatomic,strong) NSString *watchVideoScore;

@end

