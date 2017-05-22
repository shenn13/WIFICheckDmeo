//
//  WIFIHomeVC.m
//  WIFICheck-Dmeo
//
//  Created by shen on 17/3/31.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "WIFIHomeVC.h"
#import "HomeTableViewCell.h"
#import "MainPresenter.h"
#import "Device.h"
#import "OUIParser.h"

@interface WIFIHomeVC ()<UITableViewDelegate,UITableViewDataSource,MainPresenterDelegate>{
    UITableView *_tableView;
}
@property (strong, nonatomic) MainPresenter *presenter;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSLayoutConstraint *tableVTopContraint;
@end

@implementation WIFIHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.presenter = [[MainPresenter alloc]initWithDelegate:self];
    [self scanButtonClicked];
    [self addObserversForKVO];
    [OUIParser parseOUIWithSourceFilePath:nil andOutputFilePath:nil];
    [self createTableView];
}


-(void)rightButtonClicked{
    
    
    [self scanButtonClicked];
}

-(void)viewDidAppear:(BOOL)animated {
    self.title =[self.presenter ssidName];
}
#pragma mark - KVO Observers
-(void)addObserversForKVO {
    [self.presenter addObserver:self forKeyPath:@"connectedDevices" options:NSKeyValueObservingOptionNew context:nil];
    [self.presenter addObserver:self forKeyPath:@"progressValue" options:NSKeyValueObservingOptionNew context:nil];
    [self.presenter addObserver:self forKeyPath:@"isScanRunning" options:NSKeyValueObservingOptionNew context:nil];
}



-(void)scanButtonClicked {
    [self showProgressBar];
    self.title = [self.presenter ssidName];
    [self.presenter scanButtonClicked];
}


#pragma mark - Show/Hide progress
-(void)showProgressBar {
    [self.progressView setProgress:0.0];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableVTopContraint.constant=40;
        [self.view layoutIfNeeded];
    }];
}
-(void)hideProgressBar {
    [UIView animateWithDuration:0.5 animations:^{
        self.tableVTopContraint.constant=0;
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - Presenter Delegates
-(void)mainPresenterIPSearchFinished {
    [[[UIAlertView alloc] initWithTitle:@"扫描结束" message:[NSString stringWithFormat:@"共有: %lu个设备连接此WIFI", (unsigned long)self.presenter.connectedDevices.count] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
      [self hideProgressBar];
};

-(void)mainPresenterIPSearchFailed {
    [[[UIAlertView alloc] initWithTitle:@"扫描失败" message:[NSString stringWithFormat:@"请确保在扫描前连接WiFi"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
};


-(void)mainPresenterIPSearchCancelled {
    [_tableView reloadData];
};

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, kScreenWidth, kScreenHeight  - 49- 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ViewBackgroundColor;
    [self.view addSubview:_tableView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 20)];
    _progressView.progressTintColor = [UIColor redColor];
    _progressView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_progressView];
}


#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.presenter.connectedDevices count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [HomeTableViewCell cellWithTableView:tableView];
    Device *nd = [self.presenter.connectedDevices objectAtIndex:indexPath.row];
    cell.ipLabel.text = nd.ipAddress;
    cell.macAddressLabel.text = nd.macAddress;
    cell.brandLabel.text = nd.brand;
//    cell.hostnameLabel.text= nd.hostname;
    cell.image.image = [UIImage imageNamed:@"wifi_icon"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return 64;
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.presenter){
        if ([keyPath isEqualToString:@"connectedDevices"]) {
            [_tableView reloadData];
        }
        else if ([keyPath isEqualToString:@"progressValue"]) {
            
            [self.progressView setProgress:self.presenter.progressValue];
        }
        else if ([keyPath isEqualToString:@"isScanRunning"]) {
    
        }
    }
}

#pragma mark - Dealloc
-(void)dealloc {
    [self removeObserversForKVO];
}
-(void)removeObserversForKVO {
    [self.presenter removeObserver:self forKeyPath:@"connectedDevices"];
    [self.presenter removeObserver:self forKeyPath:@"progressValue"];
    [self.presenter removeObserver:self forKeyPath:@"isScanRunning"];
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
