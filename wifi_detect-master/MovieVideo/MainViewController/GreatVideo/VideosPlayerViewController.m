//
//  VideosPlayerViewController.m
//  VideosPlayer
//
//  Created by shen on 16/12/21.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "VideosPlayerViewController.h"
#import "VideosModel.h"
#import "XSMediaPlayer.h"
#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"

//选集按钮未选中颜色
#define selectButtonColor [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]
//选集选中颜色
#define selectionsBtnColor [UIColor colorWithRed:0/255.0 green:181/255.0 blue:255/255.0 alpha:1]

@import GoogleMobileAds;

@interface VideosPlayerViewController ()<UIScrollViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>{
    UIScrollView *_scrollView;
    XSMediaPlayer *_playerView;
    VideosModel *_model;
    NSMutableArray *_selecBtnArr;
    NSString *_playerUrlStr;
    
    UIButton *_selectBtn;
    NSInteger _indexTag;
    
    //判断是否隐藏集数视图
    BOOL _statu;
}

@property(nonatomic, strong) GADInterstitial *interstitial;

@property (nonatomic, assign) CGRect videoViewFrame;
@property (strong,nonatomic)UIButton *selectButton;
@property (strong, nonatomic) UIView *selecteView;//
@end

@implementation VideosPlayerViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selecBtnArr = [NSMutableArray array];
    self.view.backgroundColor = selectButtonColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayShowAd) name:@"pausePlay" object:nil];
    
    
    [self setInterstitial];
    
    [self loadAdGDTData];
    
    [self getVideosData];
 

}



-(void)getVideosData{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@v_id=%@",Detailurl,_v_id];
    [[AFNetworkingManager manager] getDataWithUrl:urlstr parameters:nil successBlock:^(id data) {
        //        NSLog(@"---------%@",data);
        for (NSDictionary *dic in data[@"data"]) {
            
            _model = [[VideosModel alloc]init];
            [_model setValuesForKeysWithDictionary:dic];
            
            for (NSDictionary *playDic in dic[@"playbody"]) {
                
                _playerUrlStr  = [NSString stringWithFormat:@"%@",playDic[@"player"]];
                
                for (NSDictionary *play in playDic[@"playinfo"]) {
                    [_selecBtnArr addObject:play];
                }
            }
        }
        
        [self createPlayerView];
        [self createSelecteView];
        
//        [[BaoHistoryManger shareManager] insertDataWithModel:_model];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
}

-(void)createPlayerView{
    
    _playerView = [[XSMediaPlayer alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight *0.4)];
    _playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playerView];
    
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button){
        
        [_playerView.player cancelPendingPrerolls];
        [_playerView.player.currentItem.asset cancelLoading];
        [_playerView.playerLayer removeFromSuperlayer];
        _playerView.player = nil;
        _playerView.playerLayer = nil;
        _playerView = nil;
        
        for (UIView * view in self.view.subviews) {
            [view removeFromSuperview];
        }
        
        if (_isPresent) {
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }];
    
    //播放完成回调
    [_playerView endPlay:^{
        //播放完毕再次加载广告
        [self setInterstitial];
        
        _selectButton.backgroundColor = [UIColor colorWithRed:137/255.0 green:197/255.0 blue:255/255.0 alpha:1];
        _selectButton.selected = !_selectButton.selected;
        
        _indexTag ++;
        
        if (_indexTag < _selecBtnArr.count) {
            
            NSString *string = [NSString stringWithFormat:@"%@",_selecBtnArr[_indexTag]];
            [self sentVideoStr:string];
            
            UIButton *nextBtn = (UIButton *)[self.view viewWithTag:_indexTag];
            if (nextBtn.isSelected == NO) {
                
                nextBtn.selected = !nextBtn.selected;
                nextBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:1];
                
                _selectButton = nextBtn;
            }
        }else{
            [_playerView.player pause];
        }
        
    }];
    
}
-(void)createSelecteView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kScreenHeight *0.4 + 10,kScreenWidth,kScreenHeight *0.6 - 10)];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(0, kScreenHeight);
    //    _scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_scrollView];
    
    UIView *selectionsView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth,400)];
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
        selections.backgroundColor = selectButtonColor;
        
        if (i == [_videoIndexTag integerValue]) {
            selections.backgroundColor = selectionsBtnColor;
            selections.selected = YES;
            _selectButton = selections;
        }
        
        [selectionsView addSubview:selections];
    }
    
    CGFloat H;
    if (_selecBtnArr.count%5==0) {
        H = ( sizeBtn.height + 10) * (_selecBtnArr.count/5);
    }else{
        H = ( sizeBtn.height + 10) * (_selecBtnArr.count/5 + 1);
    }
    selectionsView.frame = CGRectMake(0, 0, kScreenWidth,H  + CGRectGetMaxY(selectionsLB.frame) + 10);
    _scrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(selectionsView.frame) + 10);
    
    NSString *string = [NSString stringWithFormat:@"%@",_selecBtnArr[[_videoIndexTag integerValue]]];
    [self sentVideoStr:string];
}

-(void)sentVideoStr:(NSString *)str{
    
    
    [MobClick event:@"623164988"];
    
    NSRange startRange = [str rangeOfString:@"= "];
    NSRange endRange = [str rangeOfString:@"\n}"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [str substringWithRange:range];
    
    NSString *videoUrlStr = [NSString stringWithFormat:@"http://api.52kandianying.cn:81/parse.php?vid=%@&url=%@",result,_playerUrlStr];
    //    NSLog(@"------%@",videoUrlStr);
    [_playerView setVideoURL:[NSURL URLWithString:videoUrlStr]];
    
    //发送到封装好的videos里重新给vides的名字赋值
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_model.v_name,@"textOne", nil];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict]];
}

-(void)buttonClick:(UIButton *)button{
    
    //选集再次加载广告
     [self setInterstitial];
    
    if (!button.isSelected) {
        self.selectButton.selected = !self.selectButton.selected;
        
        self.selectButton.backgroundColor = selectButtonColor;
        [_playerView.player pause];
        
        button.selected = !button.selected;
        
        button.backgroundColor = selectionsBtnColor;
        
        _indexTag = button.tag ;
        
        NSString *string = [NSString stringWithFormat:@"%@",_selecBtnArr[_indexTag]];
        [self sentVideoStr:string];
        
        self.selectButton = button;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
        
    }
    _statu = !_statu;
    if (_statu) {
        
        [_scrollView removeFromSuperview];
    }else{
        [self.view addSubview:_scrollView];
    }
}
// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    return YES;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    // MoviePlayerViewController这个页面支持转屏方向
    return UIInterfaceOrientationMaskAllButUpsideDown;
    
}

//广点通广告加载
-(void)loadAdGDTData{
    
    _interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:GDT_APP_ID placementId:GDT_APP_CID];
    _interstitialObj.delegate = self;
    
    [_interstitialObj loadAd];
    
}

//初始化插页广告
- (void)setInterstitial {
    
    self.interstitial = [self createNewInterstitial];
}

//这个部分是因为多次调用 所以封装成一个方法
- (GADInterstitial *)createNewInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:AdMob_CID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

#pragma mark  广点通广告---------
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial{
    [_interstitialObj loadAd];
    
}
#pragma mark - GADInterstitialDelegate -
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
    if ([self.interstitial isReady]) {
        
        [self.interstitial presentFromRootViewController:self];
        
    }else{
        
         [_interstitialObj presentFromRootViewController:self];
    }
}
//分配失败重新分配
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    [self setInterstitial];
}

#pragma mark - GADInterstitialDelegate -
- (void)interstitialAdDidDismissFullScreenModal:(GDTMobInterstitial *)interstitial{
    
    NSLog(@"广告被关闭");
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    
}

//选集视图的显示与隐藏
-(void)pausePlayShowAd{
    
    [self setInterstitial];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pausePlay" object:nil];
    
}

@end
