//
//  SearchViewController.m
//  VideosPlayer
//
//  Created by shen on 16/12/20.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionViewCell.h"
#import "SearchModel.h"
#import "VideosDetailViewController.h"
#import "CKAlertViewController.h"


@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectView;
    NSMutableArray *_dataArr;
}
@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.title = @"搜索结果";
    
    _dataArr = [NSMutableArray array];

    
    [self getSearchDataSource];
}
-(void)getSearchDataSource{
    NSString *newStr = [_searchWord stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SearchUrl,newStr];
    
    [[AFNetworkingManager manager] getDataWithUrl:urlStr parameters:nil successBlock:^(id data) {
        
        NSLog(@"-----SearchUrl-------%@",data);
        
        for (NSDictionary *dic in data[@"data"]) {
            
            SearchModel *model = [[SearchModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArr addObject:model];
        }
        [self getSearchResultView];
        
    } failureBlock:^(NSString *error) {
        
        NSLog(@"---------------%@",error);
    }];
    
}
-(void)getSearchResultView{
    
    UIImageView *IntervalView = [PlayerTool createImageViewWithFrame:CGRectMake(0, 64,kScreenWidth , 10) ImageName:@""];
    IntervalView.backgroundColor = IntervalColor;
    [self.view addSubview:IntervalView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 74, kScreenWidth - 20, kScreenHeight - 74) collectionViewLayout:layout];
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"SearchCellID"];
    [self.view addSubview:_collectView];
    
}

#pragma mark --UICollectionViewDelegate
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

-(void)presentViewControllerToDetailViewController:(NSString *)v_id{
    
    VideosDetailViewController *videoPlayerVC = [[VideosDetailViewController alloc] init];
    videoPlayerVC.v_id = v_id;
    [self.navigationController pushViewController:videoPlayerVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
