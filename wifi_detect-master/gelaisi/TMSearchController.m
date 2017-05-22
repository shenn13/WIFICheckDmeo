//
//  TMSearchController.m
//  gelaisi
//
//  Created by lxlong on 15/7/14.
//  Copyright (c) 2015年 lxlong. All rights reserved.
//

#import "TMSearchController.h"
#import "TMWifiCell.h"
#import "UNAlertView.h"

#import "ScanLAN.h"
#import "Utils.h"
#import "IPDetector.h"

#import "CKAlertViewController.h"


@interface TMSearchController () <UITableViewDataSource, UITableViewDelegate, UtilDelegate, ScanLANDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *deepSearchBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation TMSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描设备";
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    [rightButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton addTarget:self action:@selector(searchItemDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = ViewBackgroundColor;
    
    //评论**********************************************
    [self appCommentOnTheDetails];
    //*****************************************************
    
    [self configData];
    [self configView];
    
}

- (void)searchItemDown:(id)sender {
    
    [self setBtnEnable:NO];
    [self getWlanWifi];
}

- (void)setBtnEnable:(BOOL)enable {
    self.deepSearchBtn.enabled = enable;
    self.navigationItem.rightBarButtonItem.enabled = enable;
}

- (void)configData {
    self.dataArr = @[].mutableCopy;
    [Utils shareUtils].delegate = self;
    [self getWlanWifi];
}

- (void)configView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  - 59 - 40)];
    [self.tableView registerClass:[TMWifiCell class] forCellReuseIdentifier:TMWIFICELLIDENTIFY];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = ViewBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
#define BTNOFFSET 59.0f
    self.deepSearchBtn = [UIButton new];
    [self.deepSearchBtn setTitle:@"深度扫描" forState:UIControlStateNormal];
    [self.deepSearchBtn setBackgroundColor:TMCOLOR(TM_Orange_1)];
    self.deepSearchBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.deepSearchBtn];
    
    [self.deepSearchBtn addTarget:self action:@selector(deepScanWlan:) forControlEvents:UIControlEventTouchUpInside];
    [self.deepSearchBtn autoSetDimensionsToSize:CGSizeMake(100, 30)];
    [self.deepSearchBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:- 10];
    [self.deepSearchBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:- BTNOFFSET];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMWifiCell *cell = [tableView dequeueReusableCellWithIdentifier:TMWIFICELLIDENTIFY forIndexPath:indexPath];
    cell.topic.text = self.dataArr[indexPath.row][@"address"];
    cell.stopic.text = self.dataArr[indexPath.row][@"macName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if (0 == row){
        
        [[[UIAlertView alloc] initWithTitle:@"当前设备" message:[NSString stringWithFormat:@"%@", self.dataArr[0][@"macName"]] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        
    }else{
        
        
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
        NSString *deviceStr = [[NSString alloc] initWithFormat:@"%@", dic[@"macName"]];
        
        NSArray *strArray = [deviceStr componentsSeparatedByString:@":"];
        
        NSString *key = [[NSString alloc]initWithFormat:@"%@%@%@", [strArray objectAtIndex:0], [strArray objectAtIndex:1], [strArray objectAtIndex:2]];
        
        NSString *getmsg = [[NSUserDefaults standardUserDefaults] stringForKey:key];
        
        if (getmsg != nil) {
            
            [[[UIAlertView alloc]initWithTitle:@"设备信息:" message:getmsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        NSString *getUrl = [NSString stringWithFormat:@"http://www.macvendorlookup.com/api/v2/%@", dic[@"macName"]];
        NSURL *macReqUrl = [NSURL URLWithString:getUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:macReqUrl];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError == nil) {
                NSError *error;
                NSArray *JsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    return;
                } else {
                    
                    NSArray *arrary = [JsonObject objectAtIndex:0];
                    NSString *company = [arrary valueForKey:@"company"];
                    NSString *country = [arrary valueForKey:@"country"];
                    NSString *address3 = [arrary valueForKey:@"addressL3"];
                    NSString *str = [[NSString alloc]initWithFormat:@"品牌:%@ \n 设备归属:%@ \n 产地:%@", company, country, address3];
                    //alert
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[[UIAlertView alloc] initWithTitle:@"设备信息:" message:[NSString stringWithFormat:str, company, country] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
                        
                    });
                    //store the date
                    NSString *key = [[arrary valueForKey:@"startHex"] substringWithRange:NSMakeRange(0, 6)];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:str forKey:key];
                }
            }
        }];
        
    }
}
#pragma -mark wifi scan delegate

- (void)getWlanWifi {
    
    [self.dataArr removeAllObjects];
    
    [self detectMyself];
    
    if ([IPDetector getWifiStatus]) {
        
        [[Utils shareUtils] getArpDevice];
        
    } else {
        
        [self setBtnEnable:YES];
        [[[UIAlertView alloc] initWithTitle:@"提示:" message:@"请打开链接wifi" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}

- (void)utilScanLandidFinishScanning {
    NSLog(@"scan finish...");
    [self setBtnEnable:YES];
    [self.tableView reloadData];
    [[[UIAlertView alloc] initWithTitle:@"Scan Finished" message:[NSString stringWithFormat:@"Number of devices connected to the Local Area Network : %lu", (unsigned long)self.dataArr.count] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)utilScanLANDidFindNewAdrress:(NSString *)address havingMactName:(NSString *)macName {
    if ([macName isEqualToString:@"00:00:00:00:00:00"]) {
        return;
    }
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"address"] = address;
    dic[@"macName"] = macName;
    [self.dataArr addObject:dic];
}

#pragma mark my myself method

- (void)detectMyself {
    [IPDetector getLANIPAddressWithCompletion:^(NSString *IPAddress) {
        if ([IPAddress isEqualToString:@"error"]) {
            IPAddress = @"获取不到当前设备局域网IP";
        }
        [self.dataArr insertObject:@{@"address":IPAddress, @"macName":[[UIDevice currentDevice] name]} atIndex:0];
        [_tableView reloadData];
    }];
}

#pragma mark deep scanWlanWifi

- (void)deepScanWlan:(id)sender {
    if ([IPDetector getWifiStatus]) {
        [[UNAlertView alloc] waitTitle:@"设备深度扫描中..."];
        [self setBtnEnable:NO];
        ScanLAN *scan = [[ScanLAN alloc] initWithDelegate:self];
        [scan startScan];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示:" message:@"请打开链接wifi" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
    
}

- (void)scanLANDidFindNewAdrress:(NSString *)address havingHostName:(NSString *)hostName {
    NSLog(@"%@, %@", address, hostName);
}

- (void)scanLANDidFinishScanning {
    __weak typeof(self)weakSelf = self;
    [UNAlertView hideAlertViewWithAnimation:NO];
    [weakSelf getWlanWifi];
}


-(void)appCommentOnTheDetails{
    
    [[AFNetworkingManager manager] getDataWithUrl:MarkUrl parameters:nil successBlock:^(id data) {
        //        NSLog(@"---------%@",data);
        if(![[NSString stringWithFormat:@"%@",data[@"data"]]isEqualToString:@"1"] ){
            
        }else{
            
            CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:NSLocalizedString(@"求求你，给个好评吧", nil) ];
            
            CKAlertAction *cancel = [CKAlertAction actionWithTitle:NSLocalizedString(@"不了~~", nil) handler:^(CKAlertAction *action) {
            }];
            
            CKAlertAction *sure = [CKAlertAction actionWithTitle:NSLocalizedString(@"好哒~~", nil) handler:^(CKAlertAction *action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPCommentURL]];
                
            }];
            [alertVC addAction:cancel];
            [alertVC addAction:sure];
            
            [self presentViewController:alertVC animated:NO completion:nil];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
}


@end
