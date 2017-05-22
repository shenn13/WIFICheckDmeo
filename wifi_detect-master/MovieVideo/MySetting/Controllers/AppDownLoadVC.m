//
//  AppDownLoadVC.m
//  GetLocalVideo
//
//  Created by shen on 17/4/13.
//  Copyright © 2017年 com.picovr.picovr. All rights reserved.
//

#import "AppDownLoadVC.h"

@interface AppDownLoadVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}

@end

@implementation AppDownLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataArr = [NSMutableArray array];
    
    
    [[AFNetworkingManager manager] getDataWithUrl:JumpToAPPURL parameters:nil successBlock:^(id data) {
        
         _dataArr = data[@"data"];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight  - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
    
    [self customNavigationItem];
}
    
    //自定制当前视图控制器的navigationItem
-(void)customNavigationItem{
    
    UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popDoBack)];
    
    self.navigationItem.leftBarButtonItem =  backbtn;
}
-(void)popDoBack{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [_dataArr[indexPath.row] objectForKey:@"content"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_dataArr[indexPath.row] objectForKey:@"url"]]];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return 80;
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
