//
//  MovieFirstViewController.m
//  GetLocalVideo
//
//  Created by shen on 17/2/23.
//  Copyright © 2017年 com.picovr.picovr. All rights reserved.
//

#import "MovieFirstViewController.h"
#import "SearchModel.h"
#import "SearchCollectionViewCell.h"
#import "VideosDetailViewController.h"
#import "CKAlertViewController.h"

@interface MovieFirstViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *_collectView;
    NSMutableArray *_dataArr;
    NSInteger _numPage;
    
}

@end

@implementation MovieFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataArr = [NSMutableArray array];
    
    _numPage = 1;
    
    [self getMoreDataNetworkingWithPage:1 isLoadMore:NO];
}

-(void)getMoreDataNetworkingWithPage:(NSInteger)page isLoadMore:(BOOL)isLoadMore{
    
    NSString *urlstr = [NSString stringWithFormat:@"https://api.52kandianying.cn/index.html?method=videoinfos&id=%@&page=%ld&order=hot",_classID,(long)page];
    
    [[AFNetworkingManager manager] getDataWithUrl:urlstr parameters:nil successBlock:^(id data) {
//             NSLog(@"--------%@",data);
        
        NSArray *arr = data[@"data"];
        
        if (!isLoadMore) {
            
            [_dataArr removeAllObjects];
            
        } if (arr.count == 0) {
            [_collectView.mj_footer endRefreshingWithNoMoreData];
            [[EPProgressShow showHUDManager] showInfoWithStatus:@"没有更多数据啦..."];
            
        }else {
            for (NSDictionary *dict in arr) {
                SearchModel *model = [[SearchModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
            if (!_collectView) {
                
                [self createCollectViewView];
            }
            [_collectView reloadData];
        }
        [_collectView.mj_footer endRefreshing];
        [_collectView.mj_header endRefreshing];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
        
        [_collectView.mj_footer endRefreshing];
        [_collectView.mj_header endRefreshing];
        
    }];
    
}
-(void)createCollectViewView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,- 54, kScreenWidth, kScreenHeight - 49 - 40) collectionViewLayout:layout];
    
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"SearchCellID"];
    
    _collectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    _collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_collectView.mj_header beginRefreshing];
    _collectView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.view addSubview:_collectView];
}

#pragma 下拉刷新
- (void)refreshData{

    _numPage = 1;

    [self getMoreDataNetworkingWithPage:1 isLoadMore:NO];
}
- (void)loadMoreData{
    
    _numPage ++;
    
    [self getMoreDataNetworkingWithPage:_numPage isLoadMore:YES];
    
}

#pragma mark --UICollectionViewDelegate

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 60)/3, H(160));
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCellID" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchModel *model = _dataArr[indexPath.row];
    
    if ([model.vip isEqualToString:@"vip"]) {
        
        BOOL isExchange = [[BaoHistoryManger shareManager]searchIsExistWithID:model.v_id];
        
        
        if (isExchange) {
            
             [self presentViewControllerToDetailViewController:model.v_id];
            
        }else{
            
            CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"这是VIP视频，需要消耗%@积分才能观看",model.VIPScore]];
            
            CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                NSLog(@"点击了 %@ 按钮",action.title);
            }];
            CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                
                NSString *beginScoreStr =[PDKeyChain keyChainLoad];
                int num = [beginScoreStr intValue] - [model.VIPScore intValue];
                
                if (num > 0) {
                    
                    NSString *newStr = [NSString stringWithFormat:@"%d",num];
                    [PDKeyChain keyChainSave:newStr];
                    [self presentViewControllerToDetailViewController:model.v_id];
                    [[BaoHistoryManger shareManager] insertDataWithModel:model];
                    
                }else{
                    
                    [[EPProgressShow showHUDManager] showInfoWithStatus:@"您的积分已不够，请获得积分后再来观看"];
                }

            }];
            
            [alertVC addAction:cancel];
            [alertVC addAction:sure];
            
            [self presentViewController:alertVC animated:NO completion:nil];
        }
        
        
    }else{
        [self presentViewControllerToDetailViewController:model.v_id];

    }
    
}

-(void)presentViewControllerToDetailViewController:(NSString *)v_id{
    
    VideosDetailViewController *videoPlayerVC = [[VideosDetailViewController alloc] init];
    videoPlayerVC.v_id = v_id;
    videoPlayerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoPlayerVC animated:YES];

    
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
