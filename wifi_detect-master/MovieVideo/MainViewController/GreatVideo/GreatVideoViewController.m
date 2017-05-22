//
//  GreatVideoViewController.m
//  GetLocalVideo
//
//  Created by shen on 17/2/7.
//  Copyright © 2017年 com.picovr.picovr. All rights reserved.
//

#import "GreatVideoViewController.h"
#import "FirstVideosViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"


@interface GreatVideoViewController ()<UIScrollViewDelegate>{
    NSMutableArray *_titleArr;
    NSMutableArray *_videosClassID;
}
@property (nonatomic, strong) UISegmentedControl *segmentCtrl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) FirstVideosViewController *firstVC;
@property (nonatomic, strong) SecondViewController *secondVC;
@property (nonatomic, strong) ThirdViewController *thirdVC;
@property (nonatomic, strong) FourViewController *fourthVC;
@end

@implementation GreatVideoViewController


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精彩推荐";
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleArr = [NSMutableArray array];
    _videosClassID = [NSMutableArray array];
    self.videoUrlStr =  Homeurl;
    [self getDataNetworking];
}

-(void)getDataNetworking{
    
    
    [[AFNetworkingManager manager] getDataWithUrl:self.videoUrlStr parameters:nil successBlock:^(id data) {
//        NSLog(@"------------%@",data);
        for (NSDictionary *modelDict in data[@"data"]) {
            
            for (NSDictionary *dic in modelDict[@"serieslist"]) {
                
                NSString *title = [NSString stringWithFormat:@"%@",dic[@"tname"]];
                NSString *tid = [NSString stringWithFormat:@"%@",dic[@"tid"]];
                
                [_titleArr addObject:title];
                [_videosClassID addObject:tid];
              
            }
        }
        
        [self settingSrollerView];
        [self settingSegmentCtrl];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
}

-(void)settingSrollerView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 44, kScreenWidth,kScreenHeight )];
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled = YES;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);  // 内边距
    scrollView.contentSize = CGSizeMake(kScreenWidth*4, kScreenHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    // 将四个视图加入scrollerView
    self.firstVC = [[FirstVideosViewController alloc] init];
    self.firstVC.classID = _videosClassID[0];
    self.firstVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44);
    self.secondVC = [[SecondViewController alloc] init];
    self.secondVC.classID = _videosClassID[1];
    self.secondVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - 44);
    self.thirdVC = [[ThirdViewController alloc] init];
    self.thirdVC.classID = _videosClassID[2];
    self.thirdVC.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight- 64 - 44);
    self.fourthVC = [[FourViewController alloc] init];
    self.fourthVC.classID = _videosClassID[3];
    self.fourthVC.view.frame = CGRectMake(kScreenWidth*3, 0, kScreenWidth, kScreenHeight- 64 - 44);
    [self addChildViewController:self.firstVC];
    [self addChildViewController:self.secondVC];
    [self addChildViewController:self.thirdVC];
    [self addChildViewController:self.fourthVC];
    
    
    [scrollView addSubview:self.firstVC.view];
    [scrollView addSubview:self.secondVC.view];
    [scrollView addSubview:self.thirdVC.view];
    [scrollView addSubview:self.fourthVC.view];
    _scrollView = scrollView;
}

#pragma mark -- scrollerView 代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    self.segmentCtrl.selectedSegmentIndex = offset/kScreenWidth;
}

-(void)settingSegmentCtrl{
    
    UISegmentedControl *segmentCtrl = [[UISegmentedControl alloc] initWithItems:_titleArr];
    [self.view addSubview:segmentCtrl];
    
    
    segmentCtrl.frame = CGRectMake(0, 64, kScreenWidth, 44);
    segmentCtrl.selectedSegmentIndex = 0;
    // 设置test空间的颜色为透明
    segmentCtrl.tintColor = [UIColor clearColor];
    // 定义未选中状态下的样式normal,类型为字典
    NSDictionary *normal = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                             NSForegroundColorAttributeName:COLOR(130, 130, 130, 0.8)};
    // 定位选中状态下的样式selected，类型为字典
    NSDictionary *selected = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName:COLOR(255, 64, 64, 0.8)};
    // 通过setTitleTextAttributes: forState: 方法来给test控件设置文字内容的格式
    [segmentCtrl setTitleTextAttributes:normal forState:UIControlStateNormal];
    [segmentCtrl setTitleTextAttributes:selected forState:UIControlStateSelected];
    [segmentCtrl addTarget:self action:@selector(segmentBtnClick) forControlEvents:UIControlEventValueChanged];
    
    _segmentCtrl = segmentCtrl;
}

// 点击segmentCtrl 调用方法
- (void)segmentBtnClick{
    self.scrollView.contentOffset = CGPointMake(self.segmentCtrl.selectedSegmentIndex * self.view.frame.size.width, 0);
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
