//
//  CollectViewController.m
//  MyCenterSetting
//
//  Created by shen on 17/3/4.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "CollectViewController.h"
#import "SearchModel.h"
#import "SearchCollectionViewCell.h"
#import "VideosDetailViewController.h"

@interface CollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UICollectionView *_collectView;
    NSMutableArray *_dataArr;
}

@end

@implementation CollectViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
    _dataArr = [NSMutableArray array];
    
    [self createCollectViewView];
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

-(void)createCollectViewView{
    
    
    [_dataArr addObjectsFromArray:[[BaoHistoryManger shareManager] searchAllData]];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"SearchCellID"];
    [self.view addSubview:_collectView];
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
    VideosDetailViewController *videoPlayerVC = [[VideosDetailViewController alloc] init];
    videoPlayerVC.v_id = model.v_id;
    [self.navigationController pushViewController:videoPlayerVC animated:YES];
    
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
