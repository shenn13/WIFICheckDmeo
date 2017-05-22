//
//  WIFILocalMsgVC.m
//  WIFICheck-Dmeo
//
//  Created by shen on 17/3/31.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "WIFILocalMsgVC.h"
#import "QBDeviceInfo.h"

@import GoogleMobileAds;
@interface WIFILocalMsgVC ()<YUFoldingTableViewDelegate>{
    
    NSArray *_titleArr;
    NSArray *_wifiMsgArr;
    NSArray *_phoneMsgArr;
    NSArray *_appMsgArr;
    
    GADBannerView *_bannerView;
}

@property (nonatomic, weak) YUFoldingTableView *foldingTableView;


@end

@implementation WIFILocalMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"本机信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
      self.view.backgroundColor = ViewBackgroundColor;
    
    [self getLocalMsgView];
    // 创建tableView
    [self setupFoldingTableView];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGPoint origin = CGPointMake(0, kScreenHeight - 65 - 49);
    _bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(kScreenWidth, 65)) origin:origin];
    _bannerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bannerView];
    
    _bannerView.adUnitID = AdMob_BannerViewAdUnitID;
    _bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [_bannerView loadRequest:request];
    
}


-(void)getLocalMsgView{
    
    //设备名称--Simulator
    NSString * deviceName =[NSString stringWithFormat:@"设备:%@",[QBDeviceInfo deviceName]];
    //系统时间
    NSString * timestampString = [NSString stringWithFormat:@"系统时间:%@",[QBDeviceInfo applicationTimestampString]];
    //系统版本--10.2
    NSString * systemVersion = [NSString stringWithFormat:@"系统版本:%@",[QBDeviceInfo phoneSystemVersion]];
    //当前语言--en
    NSString * preferredLanguage = [NSString stringWithFormat:@"当前语言设置:%@",[QBDeviceInfo systemPreferredLanguage]];
    //剩余电量---1.000000
    //    CGFloat batteryLevel = [QBDeviceInfo batteryLevel];
    //总内存容量
    NSString *totalMemorySize = [NSString stringWithFormat:@"内存容量:%@",[QBDeviceInfo fileSizeToString:[QBDeviceInfo totalMemorySize]]];
    //可用内存
    NSString *availableMemorySize = [NSString stringWithFormat:@"可用内存:%@",[QBDeviceInfo fileSizeToString:[QBDeviceInfo availableMemorySize]]];
    //总空间
    NSString *totalDiskSize =[NSString stringWithFormat:@"总储存空间:%@", [QBDeviceInfo fileSizeToString:[QBDeviceInfo totalDiskSize]]];
    //可用空间
    NSString *availableDiskSize = [NSString stringWithFormat:@"可用空间:%@",[QBDeviceInfo fileSizeToString:[QBDeviceInfo availableDiskSize]]];
    //IDFA--
    NSString * idfa = [NSString stringWithFormat:@"IDFA:%@",[QBDeviceInfo advertisingIdentifier]];
    //IDFV
    NSString * idfv = [NSString stringWithFormat:@"IDFV:%@",[QBDeviceInfo identifierForVendor]];
    //是否越狱
    BOOL jailbroken = [QBDeviceInfo jailbrokenDevice];
    NSString *broken;
    if (jailbroken == YES) {
        broken =@"是否越狱:已越狱";
    }else{
        broken = @"是否越狱:未越狱";
    }
    _phoneMsgArr = [[NSArray alloc] initWithObjects:deviceName,timestampString,systemVersion,preferredLanguage,totalMemorySize,availableMemorySize,totalDiskSize,availableDiskSize,idfa,idfv,broken, nil];
    
    //WifiName
    NSString * wifiName = [NSString stringWithFormat:@"WIFI名称:%@",[QBDeviceInfo wifiName]];
    //IP--
    NSString * ipAddress = [NSString stringWithFormat:@"IP:%@",[QBDeviceInfo deviceIpAddress]];
    
    //WifiIP
    NSString * wifiIpAddress = [NSString stringWithFormat:@"WIFIIP:%@",[QBDeviceInfo localWifiIpAddress]];
    
    //DNS--
    NSString * dns = [NSString stringWithFormat:@"DNS:%@",[QBDeviceInfo domainNameSystemIp]];
    //运营商-
    //    NSString * telephonyCarrier = [NSString stringWithFormat:@"营运商:%@",[QBDeviceInfo telephonyCarrier]];
    //网络接入类型
    NSString * networkType = [NSString stringWithFormat:@"网络接入类型:%@",[QBDeviceInfo networkType]];
    //MCC-
    //    NSString * mobileCountryCode = [NSString stringWithFormat:@"MCC:%@",[QBDeviceInfo mobileCountryCode]];
    
    //MNC-
    //    NSString * mobileNetworkCode = [NSString stringWithFormat:@"MNC:%@",[QBDeviceInfo mobileNetworkCode]];
    
    _wifiMsgArr = [[NSArray alloc] initWithObjects:wifiName,ipAddress,wifiIpAddress,dns,networkType, nil];
    
    //应用名称
    NSString * appDisplayName = [NSString stringWithFormat:@"APP名称:%@",[QBDeviceInfo applicationDisplayName]];
    //应用版本
    NSString * appVersion =[NSString stringWithFormat:@"APP版本:%@", [QBDeviceInfo applicationVersion]];
    _appMsgArr = [[NSArray alloc] initWithObjects:appDisplayName,appVersion, nil];
}
// 创建tableView
- (void)setupFoldingTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _titleArr = @[@"手机信息",@"网络信息",@"关于APP"];
    
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49 - 65)];
    _foldingTableView = foldingTableView;
    _foldingTableView.backgroundColor = ViewBackgroundColor;
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingDelegate = self;
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView{
    return self.arrowPosition ? :YUFoldingSectionHeaderArrowPositionLeft;
}
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView{
    return _titleArr.count;
}
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section{
    
    if (section == 0) {
        return _phoneMsgArr.count;
    }
    if (section == 1) {
        
        return _wifiMsgArr.count;
    }
    if (section == 2) {
        return _appMsgArr.count;
    }
    return 3;
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section{
    return 50;
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%@",_titleArr[section]];
}

- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [yuTableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.section ==0 ) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_phoneMsgArr[indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_wifiMsgArr[indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }if (indexPath.section == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_appMsgArr[indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    return cell;
}
- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section{
    return @"点击查看详情";
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
