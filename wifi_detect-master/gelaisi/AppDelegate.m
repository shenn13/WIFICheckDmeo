//
//  AppDelegate.m
//  gelaisi
//
//  Created by lxlong on 15/7/13.
//  Copyright (c) 2015年 lxlong. All rights reserved.
//

#import "AppDelegate.h"

#import "WIFITabBarVC.h"

#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

@interface AppDelegate (){
    
    NSMutableArray *_APPURLSchemeStr;
}


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#ifndef DEBUG
    
#endif
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    //开屏广告初始化并展示代码
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        GDTSplashAd *splashAd = [[GDTSplashAd alloc] initWithAppkey:GDT_APP_ID placementId:GDT_APP_KID];
        splashAd.delegate = self;//设置代理1ez
        //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
        if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
        } else {
            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]];
        }
        //设置开屏拉取时长限制，若超时则不再展示广告
        splashAd.fetchDelay = 3;
        //［可选］拉取并展示全屏开屏广告
        [splashAd loadAdAndShowInWindow:self.window];
        
        self.splash = splashAd;
    }
    
    
    UMConfigInstance.appKey = UM_APP_KEY;
    UMConfigInstance.channelId = nil;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    
    
    WIFITabBarVC *tabbarVC = [WIFITabBarVC new];
    self.window.rootViewController = tabbarVC;

    
    [self getScoreValue];
    [self checkKeyChain];
    
    
    [ShareSDK registerApp:@"1cd6cb162b8b0"
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                            appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:@"100371282"
                                           appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                         authType:SSDKAuthTypeSSO];
                      break;
                  default:
                      break;
              }
          }];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    return YES;
}

- (void)checkKeyChain {
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [PDKeyChain keyChainSave:@"1000"];
        NSLog(@"-===============================");
    }else{
        
    }
}

-(void)getScoreValue{
    
    [[AFNetworkingManager manager] getDataWithUrl:ScoreURL parameters:nil successBlock:^(id data) {
        
        NSArray *scoreArr = data[@"data"];
        _appCommentScore = [scoreArr[0] objectForKey:@"score"];
        _appDownLoadScore = [scoreArr[1] objectForKey:@"score"];
        _shareScore = [scoreArr[2] objectForKey:@"score"];
        _watchVideoScore = [scoreArr[3] objectForKey:@"score"];
        
        [self appIsExistYesOrNo];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
}

-(void)appIsExistYesOrNo{
    
    _APPURLSchemeStr = [NSMutableArray array];
    
    //判断本地是否有App
    //探探
    NSURL *yuanFenBaURLStr = [NSURL URLWithString:@"yuanfenba://"];
    //95秀
    NSURL *beautyShowURLStr = [NSURL URLWithString:@"beautyshow://"];
    //棋牌游戏
    NSURL *QiPaiYouXiURLStr = [NSURL URLWithString:@"qipaiyouxi0214://"];
    //交友
    NSURL *JiaoYou0214URLStr = [NSURL URLWithString:@"jiaoyou0214://"];
    
    
    [[AFNetworkingManager manager] getDataWithUrl:JumpToAPPURL parameters:nil successBlock:^(id data) {
        
        _APPURLSchemeStr = data[@"data"];
        
        if ([[UIApplication sharedApplication] canOpenURL:yuanFenBaURLStr]) {
            
            //   [[UIApplication sharedApplication] openURL:myURL_APP_A];
            
            //  获得权限
            _yuanFenBaURLSchemesIsOnStr = [_APPURLSchemeStr[0] objectForKey:@"title"];
            
        }else{
            
            _yuanFenBaURLSchemesIsOnStr = @"";
        }
        
        if([[UIApplication sharedApplication] canOpenURL:beautyShowURLStr]){
            
            _beautyShowURLSchemesIsOnStr = [_APPURLSchemeStr[1] objectForKey:@"title"];
            
        }else{
            
            _beautyShowURLSchemesIsOnStr = @"";
        }
        if([[UIApplication sharedApplication] canOpenURL:QiPaiYouXiURLStr]){
            
            _qiPaiYouXi0214URLSchemesIsOnStr = [_APPURLSchemeStr[2] objectForKey:@"title"];
            
        }else{
            _qiPaiYouXi0214URLSchemesIsOnStr = @"";
        }
        if([[UIApplication sharedApplication] canOpenURL:JiaoYou0214URLStr]){
            
            _jiaoYou0214URLSchemesIsOnStr = [_APPURLSchemeStr[3] objectForKey:@"title"];
            
        }else{
            _jiaoYou0214URLSchemesIsOnStr = @"";
        }
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    static dispatch_once_t disOnce;
    dispatch_once(&disOnce,^ {
        //探探
        NSURL *yuanFenBaURLStr = [NSURL URLWithString:@"yuanfenba://"];
        //95秀
        NSURL *beautyShowURLStr = [NSURL URLWithString:@"beautyshow://"];
        //棋牌游戏
        NSURL *QiPaiYouXiURLStr = [NSURL URLWithString:@"qipaiyouxi0214://"];
        //交友
        NSURL *JiaoYou0214URLStr = [NSURL URLWithString:@"jiaoyou0214://"];
        
        if ([[UIApplication sharedApplication] canOpenURL:yuanFenBaURLStr]) {
            
            //   [[UIApplication sharedApplication] openURL:myURL_APP_A];
            
            //  获得权限
            _yuanFenBaURLSchemesIsOnStr = [_APPURLSchemeStr[0] objectForKey:@"title"];
            
            [self addScore:[_appDownLoadScore intValue]];
            
        }else{
            
            _yuanFenBaURLSchemesIsOnStr = @"";
        }
        
        if([[UIApplication sharedApplication] canOpenURL:beautyShowURLStr]){
            
            _beautyShowURLSchemesIsOnStr = [_APPURLSchemeStr[1] objectForKey:@"title"];
            [self addScore:[_appDownLoadScore intValue]];
        }else{
            
            _beautyShowURLSchemesIsOnStr = @"";
        }
        if([[UIApplication sharedApplication] canOpenURL:QiPaiYouXiURLStr]){
            
            _qiPaiYouXi0214URLSchemesIsOnStr = [_APPURLSchemeStr[2] objectForKey:@"title"];
            [self addScore:[_appDownLoadScore intValue]];
        }else{
            _qiPaiYouXi0214URLSchemesIsOnStr = @"";
        }
        if([[UIApplication sharedApplication] canOpenURL:JiaoYou0214URLStr]){
            
            _jiaoYou0214URLSchemesIsOnStr = [_APPURLSchemeStr[3] objectForKey:@"title"];
            [self addScore:[_appDownLoadScore intValue]];
            
        }else{
            _jiaoYou0214URLSchemesIsOnStr = @"";
        }
    });

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)addScore:(int)score{
    
    NSString  *beginScoreStr =[PDKeyChain keyChainLoad];
    int num =score + [beginScoreStr intValue];
    NSString *newStr = [NSString stringWithFormat:@"%d",num];
    [PDKeyChain keyChainSave:newStr];
}

@end
