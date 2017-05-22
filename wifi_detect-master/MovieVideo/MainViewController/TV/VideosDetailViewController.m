//
//  VideosDetailViewController.m
//  VideosPlayer
//
//  Created by shen on 17/2/9.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "VideosDetailViewController.h"
#import "VideosModel.h"
#import "VideosPlayerViewController.h"
#import "AppDelegate.h"


//选集按钮未选中颜色
#define selectButtonColor [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]
//选集选中颜色
#define selectionsBtnColor [UIColor colorWithRed:0/255.0 green:181/255.0 blue:255/255.0 alpha:1]

@import GoogleMobileAds;

@interface VideosDetailViewController ()<GADNativeExpressAdViewDelegate, GADVideoControllerDelegate>{
    
    GADNativeExpressAdView *_nativeExpressAdView;
    
    UIScrollView *_scrollView;
    NSMutableArray *_selecBtnArr;
    VideosModel *_model;
    UIButton *_selectButton;
    NSInteger _indexTag;
    
    
}

@property (strong,nonatomic)UIButton *selectButton;
@property (nonatomic, assign) CGRect videoViewFrame;

@end

@implementation VideosDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"视频详情";
    
    _selecBtnArr = [NSMutableArray array];
    
    [self addNativeExpressAdView];
    
    [self getVideosPlayerData];
    
    [self customNavigationItem];
    
}
//自定制当前视图控制器的navigationItem
-(void)customNavigationItem{
    
    UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popDoBack)];
    
    self.navigationItem.leftBarButtonItem =  backbtn;
}
-(void)popDoBack{
    
    if (_isPresent) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

-(void)getVideosPlayerData{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@v_id=%@",Detailurl,_v_id];
    [[AFNetworkingManager manager] getDataWithUrl:urlstr parameters:nil successBlock:^(id data) {
        //        NSLog(@"---------%@",data);
        for (NSDictionary *dic in data[@"data"]) {
            
            _model = [[VideosModel alloc]init];
            [_model setValuesForKeysWithDictionary:dic];
            
            for (NSDictionary *playDic in dic[@"playbody"]) {
                
                for (NSDictionary *play in playDic[@"playinfo"]) {
                    
                    [_selecBtnArr addObject:play];
                }
            }
        }
        
        [self addScrollView];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
}

-(void)addScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nativeExpressAdView.frame), kScreenWidth, kScreenHeight - _nativeExpressAdView.height - 64)];
    _scrollView.scrollEnabled = YES;
    _scrollView.backgroundColor = selectButtonColor;
    _scrollView.contentSize = CGSizeMake(0, kScreenHeight);
    [self.view addSubview:_scrollView];
    
    UIView *introductionView = [PlayerTool createViewWithFrame:CGRectMake(0,0 , kScreenWidth, 100)];
    introductionView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:introductionView];
    
    UIImageView *videosPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    [videosPicView sd_setImageWithURL:[NSURL URLWithString:_model.v_pic] placeholderImage:nil];
    [introductionView addSubview:videosPicView];
    
    UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(videosPicView.frame) + 10, 0, kScreenWidth - CGRectGetMaxX(videosPicView.frame) -10  ,90)];
    contentView.font = [UIFont systemFontOfSize:14];
    contentView.text = [NSString stringWithFormat:@"剧情简介:%@",_model.content];
    contentView.editable = NO;
    [introductionView addSubview:contentView];
    
    UIView *selectionsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introductionView.frame) + 10, kScreenWidth,400)];
    selectionsView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:selectionsView];
    
    UILabel *selectionsLB = [PlayerTool createLabelWithFrame:CGRectMake(10, 0 , kScreenWidth, 30) Font:16 Text:@"选集"];
    [selectionsView addSubview:selectionsLB];
    
    CGSize sizeBtn = CGSizeMake((selectionsView.width - 60)/5,50);
    for (int i = 0; i < _selecBtnArr.count; i ++ ) {
        CGFloat x = self.videoViewFrame.origin.x;
        CGFloat y = self.videoViewFrame.origin.y;
        if (i != 0) {
            x += sizeBtn.width;
        }else {
            y += CGRectGetMaxY(selectionsLB.frame) + 10;
        }
        CGFloat minX = x;
        CGFloat maxX = x + sizeBtn.width;
        if (maxX > CGRectGetWidth(selectionsView.frame)) {
            x -= minX;
            y = y + sizeBtn.height + 10;
        }
        CGRect rect = CGRectMake(x + 10, y, sizeBtn.width, sizeBtn.height);
        self.videoViewFrame = rect;
        UIButton *selections = [PlayerTool createButtonWithFrame:rect backGruondImageName:@"" Target:self Action:@selector(buttonClick:) Title:[NSString stringWithFormat:@"%d",i + 1]];
        selections.tag = i;
        selections.backgroundColor = selectButtonColor;
        [selectionsView addSubview:selections];
    }
    
    
    CGFloat H;
    if (_selecBtnArr.count%5==0) {
        H = ( sizeBtn.height + 10) * (_selecBtnArr.count/5);
    }else{
        H = ( sizeBtn.height + 10) * (_selecBtnArr.count/5 + 1);
    }
    selectionsView.frame = CGRectMake(0, CGRectGetMaxY(introductionView.frame) + 10, kScreenWidth,H  + CGRectGetMaxY(selectionsLB.frame) + 10);
    
    _scrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(selectionsView.frame) + 10);
    
}


-(void)buttonClick:(UIButton *)button{
    
    _indexTag = button.tag ;
    VideosPlayerViewController  *videosVC = [[VideosPlayerViewController alloc] init];
    videosVC.v_id = _v_id;
    videosVC.videoIndexTag = [NSString stringWithFormat:@"%ld",(long)_indexTag];
    videosVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videosVC animated:NO];
    
}

-(void)addNativeExpressAdView{
    
    CGPoint origin = CGPointMake(0, 64);
    _nativeExpressAdView = [[GADNativeExpressAdView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(kScreenWidth, 250)) origin:origin];
    [self.view addSubview:_nativeExpressAdView];
    
    _nativeExpressAdView.adUnitID = AdMob_NativeExpressAdUnitID;
    _nativeExpressAdView.rootViewController = self;
    _nativeExpressAdView.delegate = self;
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = true;
    [_nativeExpressAdView setAdOptions:@[ videoOptions ]];
    _nativeExpressAdView.videoController.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [_nativeExpressAdView loadRequest:request];
}


#pragma mark - GADNativeExpressAdViewDelegate

- (void)nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView {
    if (nativeExpressAdView.videoController.hasVideoContent) {
        
        //        NSLog(@"Received ad an with a video asset.");
        
    } else {
        
        //        NSLog(@"Received ad an without a video asset.");
    }
}

#pragma mark - GADVideoControllerDelegate

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    
    //    NSLog(@"Playback has ended for this ad's video asset.");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//支持旋转
-(BOOL)shouldAutorotate{
    return NO;
}
//支持的方向 因为界面A我们只需要支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
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
