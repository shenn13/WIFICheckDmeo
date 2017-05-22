//
//  MySettingViewController.m
//  MyCenterSetting
//
//  Created by shen on 17/3/3.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "MySettingViewController.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "XBSettingCell.h"
#import "CollectViewController.h"
#import "AppDownLoadVC.h"

#import "EPProgressShow.h"
#import <UnityAds/UnityAds.h>
#import "AppDelegate.h"

#import "SuggestionsViewController.h"

#import "GGActionSheet.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "XHVersion.h"

@interface MySettingViewController ()<UnityAdsDelegate,UITableViewDelegate,UITableViewDataSource,GGActionSheetDelegate>{
    AppDelegate *_appDelegate;
    
    NSArray *_sectionArr;
    UILabel *_scoreLabel;
    NSString *_beginScoreStr;
    NSString *_endScoreStr;
    
    UITableView *_tableView;
}
@property(nonatomic,strong) GGActionSheet *actionSheetTitle;

@end

@implementation MySettingViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.rightBarButtonItem = nil;
    
    NSString *scoreStr= [PDKeyChain keyChainLoad];
    _scoreLabel.text = [NSString stringWithFormat:@"你所拥有的积分:%@",scoreStr];
    [_tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的";
    
    [UnityAds initialize:UnityAds_APP delegate:self];
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self setupSections];
    [self setHeaderView];
    
}

-(GGActionSheet *)actionSheetTitle{
    if (!_actionSheetTitle) {
        _actionSheetTitle = [GGActionSheet ActionSheetWithTitleArray:@[@"分享到QQ",@"分享到微信"] andTitleColorArray:@[[UIColor blackColor]] delegate:self];
        _actionSheetTitle.cancelDefaultColor = [UIColor redColor];
        _actionSheetTitle.optionDefaultColor = [UIColor blackColor];
    }
    return _actionSheetTitle;
}



-(void)setHeaderView{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    header.backgroundColor = kMainScreenColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, (header.height - 120)/2, 100, 100)];
    imageView.layer.cornerRadius = imageView.width/2;
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:@"logoimage"];
    [header addSubview:imageView];
    
    
    NSString *scoreStr= [PDKeyChain keyChainLoad];
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), kScreenWidth, 40)];
    _scoreLabel.text = [NSString stringWithFormat:@"你所拥有的积分:%@",scoreStr];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:_scoreLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight  - 49 - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = header;
    [self.view addSubview:_tableView];
}

-(void)setupSections{
    
    XBSettingItemModel *secItem1 = [[XBSettingItemModel alloc] init];
    secItem1.funcName = @"清除缓存";
    secItem1.detailImage = [UIImage imageNamed:@"about"];
    secItem1.detailText = @"";
    secItem1.executeCode = ^{
        
        [self wipeCache];
    };
    secItem1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *secItem2 = [[XBSettingItemModel alloc] init];
    secItem2.funcName = @"已兑换视频";
    secItem2.img = [UIImage imageNamed:@""];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:[[BaoHistoryManger shareManager] searchAllData]];
    secItem2.detailText = [NSString stringWithFormat:@"共%ld个",arr.count];
    secItem2.executeCode = ^{
        [self collect];
    };
    secItem2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[secItem1,secItem2];
    
    /********************************************************************************************/
    
    XBSettingItemModel *secItem3 = [[XBSettingItemModel alloc] init];
    secItem3.funcName = @"APP评分";
    secItem3.img = [UIImage imageNamed:@""];
    secItem3.detailText = [NSString stringWithFormat:@"评分获得%@积分",_appDelegate.appCommentScore];
    secItem3.executeCode = ^{
        [self giveMeStar:[_appDelegate.appCommentScore intValue]];
    };
    secItem3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    XBSettingItemModel *secItem4 = [[XBSettingItemModel alloc] init];
    secItem4.funcName = @"下载APP";
    secItem4.img = [UIImage imageNamed:@""];
    secItem4.detailText = [NSString stringWithFormat:@"下载APP获得%@积分",_appDelegate.appDownLoadScore];
    secItem4.executeCode = ^{
        [self downLoadApp];
    };
    secItem4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    XBSettingItemModel *secItem5 = [[XBSettingItemModel alloc] init];
    secItem5.funcName = @"分享";
    secItem5.img = [UIImage imageNamed:@""];
    secItem5.detailText = [NSString stringWithFormat:@"分享获得%@积分",_appDelegate.shareScore];
    secItem5.executeCode = ^{
        
        [self.actionSheetTitle showGGActionSheet];
    };
    secItem5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    XBSettingItemModel *secItem6 = [[XBSettingItemModel alloc] init];
    secItem6.funcName = @"观看视频";
    secItem6.img = [UIImage imageNamed:@""];
    secItem6.detailText = [NSString stringWithFormat:@"观看视频获得%@积分",_appDelegate.watchVideoScore];
    secItem6.executeCode = ^{
        
        [self watchVideos];
    };
    secItem6.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[secItem3,secItem4,secItem5,secItem6];
    
    /********************************************************************************************/
    
    
    XBSettingItemModel *secItem7 = [[XBSettingItemModel alloc] init];
    secItem7.funcName = @"建议反馈";
    secItem7.executeCode = ^{
        [self.navigationController pushViewController:[SuggestionsViewController new] animated:YES];
    };
    secItem7.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    XBSettingItemModel *secItem8 = [[XBSettingItemModel alloc] init];
    secItem8.funcName = @"关于APP";
    secItem8.img = [UIImage imageNamed:@""];
    secItem8.detailText = @"版本1.01";
    secItem8.executeCode = ^{
        NSLog(@"关于APP");
    };
    secItem8.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    XBSettingItemModel *secItem9 = [[XBSettingItemModel alloc] init];
    secItem9.funcName = @"检测更新";
    secItem9.executeCode = ^{
        [self update];
    };
    secItem9.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section3 = [[XBSettingSectionModel alloc]init];
    section3.sectionHeaderHeight = 18;
    section3.itemArray = @[secItem7,secItem8,secItem9];
    
    _sectionArr = @[section1,section2,section3];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    XBSettingSectionModel *sectionModel = _sectionArr[section];
    return sectionModel.itemArray.count;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"setting";
    XBSettingSectionModel *sectionModel = _sectionArr[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = itemModel;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    XBSettingSectionModel *sectionModel = _sectionArr[section];
    return sectionModel.sectionHeaderHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = _sectionArr[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        
        itemModel.executeCode();
        
    }
}
//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    XBSettingSectionModel *sectionModel = [_sectionArr firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

/*******
 1,清除缓存
 *******/
-(void)wipeCache{
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"总共有%.2fM缓存",[self getCanchSize]] preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //清除磁盘
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        //清除内存
        [[SDImageCache sharedImageCache] clearMemory];
        
        [_tableView reloadData];
        
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //取消
    }]];
    [self presentViewController:sheet animated:YES completion:nil];
}

-(CGFloat )getCanchSize{
    
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    return imageCacheSize*1.0/(1024*1024);
    
}

/*******
 2,收藏
 *******/

-(void)collect{
    
    CollectViewController *collectVC = [[CollectViewController alloc] init];
    collectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectVC animated:YES];
}

/*******
 3, app评分
 *******/

- (void)giveMeStar:(int)commentScore{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPCommentURL]];
    static dispatch_once_t disOnce;
    dispatch_once(&disOnce,^ {
        
        [self addScore:commentScore];
    });
    
}

/*******
 4,下载APP
 *******/
-(void)downLoadApp{
    
    AppDownLoadVC *appVC = [[AppDownLoadVC alloc] init];
    appVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:appVC animated:YES];
}

/*******
 5,分享
 *******/
#pragma mark - GGActionSheet代理方法
-(void)GGActionSheetClickWithIndex:(int)index{
    
    if (index == 0) {
        [self showActionShareTypeQQ];
        
    }else if (index == 1){
        
        [self showActionShareWechat];
    }
}

- (void)showActionShareTypeQQ{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logoimage"]];
    if (imageArray){
        [shareParams SSDKSetupShareParamsByText:@"快点告诉你的小伙伴一起来玩吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:APPDownURL]
                                          title:@"来吧，来玩吧！！"
                                           type:SSDKContentTypeAuto];
    }
    [ShareSDK share:SSDKPlatformTypeQQ
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state){
             case SSDKResponseStateSuccess:{
                 [[EPProgressShow showHUDManager] showSuccessWithStatus:@"分享QQ成功"];
                 [self addScore:[_appDelegate.shareScore intValue]];
                 
                 break;
             }
             case SSDKResponseStateFail:{
                 
                 [[EPProgressShow showHUDManager] showErrorWithStatus:@"分享QQ失败"];
                 break;
             }
             case SSDKResponseStateCancel:{
                 [[EPProgressShow showHUDManager] showInfoWithStatus:@"分享QQ已取消"];
                 break;
             }
             default:
                 break;
         }
         
     }];
}


- (void)showActionShareWechat{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logoimage"]];
    if (imageArray){
        [shareParams SSDKSetupShareParamsByText:@"快点告诉你的小伙伴一起来玩吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:APPDownURL]
                                          title:@"来吧，来玩吧！！"
                                           type:SSDKContentTypeAuto];
    }
    [ShareSDK share:SSDKPlatformTypeWechat
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state){
             case SSDKResponseStateSuccess:{
                 [[EPProgressShow showHUDManager] showSuccessWithStatus:@"分享QQ成功"];
                 
                 [self addScore:[_appDelegate.shareScore intValue]];
                 
                 break;
             }
             case SSDKResponseStateFail:{
                 [[EPProgressShow showHUDManager] showErrorWithStatus:@"分享微信失败"];
                 break;
             }
             case SSDKResponseStateCancel:{
                 [[EPProgressShow showHUDManager] showInfoWithStatus:@"分享微信已取消"];
                 break;
             }
             default:
                 break;
         }
     }];
}



/*******
 6，视频激励广告
 *******/

-(void)watchVideos{
    
    if ([UnityAds isReady]) {
        [UnityAds show:self placementId:@"rewardedVideo"];
    } else{
        [[EPProgressShow showHUDManager] showInfoWithStatus:@"还没准备好,稍等片刻再试..."];
    }
}

- (void)unityAdsReady:(NSString *)placementId{
    NSLog(@"unityAdsReady");
}

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped {
    if(!skipped){
        NSLog(@"[UnityAds] reward user according to the zone id, rewardItemKey no longer used");
    }
}

- (void)unityAdsFetchCompleted {
    NSLog(@"unityAdsFetchCompleted");
}
- (void)unityAdsFetchFailed {
    NSLog(@"unityAdsFetchFailed");
}
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    NSLog(@"unityAdsDidError");
}
- (void)unityAdsDidStart:(NSString *)placementId{
    NSLog(@"unityAdsDidStart");
}
- (void)unityAdsDidFinish:(NSString *)placementId
          withFinishState:(UnityAdsFinishState)state{
    NSLog(@"unityAdsDidFinish ------------------------------------%ld",(long)state);
    
    if (state == kUnityAdsFinishStateCompleted) {
        [self addScore:[_appDelegate.watchVideoScore intValue]];
    }else{
        [[EPProgressShow showHUDManager] showErrorWithStatus:@"获得积分失败"];
        
    }
    
}
/*******
 7，检测更新
 *******/
-(void)update{
    
    [XHVersion checkNewVersion];
}

-(void)addScore:(int)score{
    
    _beginScoreStr =[PDKeyChain keyChainLoad];
    int num =score + [_beginScoreStr intValue];
    NSString *newStr = [NSString stringWithFormat:@"%d",num];
    [PDKeyChain keyChainSave:newStr];
    _endScoreStr = [PDKeyChain keyChainLoad];
    _scoreLabel.text = [NSString stringWithFormat:@"你所拥有的积分:%@",_endScoreStr];
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
