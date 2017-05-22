//
//  MovieBaseViewController.m
//  GetLocalVideo
//
//  Created by shen on 17/2/25.
//  Copyright © 2017年 com.picovr.picovr. All rights reserved.
//

#import "MovieBaseViewController.h"
#import "PYSearchViewController.h"
#import "SearchViewController.h"

@interface MovieBaseViewController (){
    
    NSMutableArray *_hotWordData;
}

@end

@implementation MovieBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:kMainScreenColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    _hotWordData = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:246.0/255 alpha:1];
    
    [self customNavigationRightItem];
    
    [self getHotWordData];
}



//搜索关键字
-(void)getHotWordData{
    [[AFNetworkingManager manager] getDataWithUrl:HotWordurl parameters:nil successBlock:^(id data) {
        for (NSDictionary *dict in data[@"data"]) {
            
            NSString *v_name = dict[@"v_name"];
            [_hotWordData addObject:v_name];
        }
        
    } failureBlock:^(NSString *error) {
        
        NSLog(@"---------------%@",error);
    }];
}

-(void)customNavigationRightItem{


    UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popDoBack)];
    self.navigationItem.leftBarButtonItem =  backbtn;


    UIButton *rightBtn = [PlayerTool createButtonWithFrame:CGRectMake(0, 10, 27, 27) backGruondImageName:@"rightItem.png" Target:self Action:@selector(jumpToSearchView) Title:@""];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}

-(void)jumpToSearchView{
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:_hotWordData searchBarPlaceholder:@"搜索电影名字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.searchWord = searchText;
        [searchViewController.navigationController pushViewController:searchVC animated:NO];
    }];
    
    searchViewController.hotSearchStyle = PYHotSearchStyleRankTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    nav.navigationBar.barTintColor = kMainScreenColor;
    [self presentViewController:nav  animated:NO completion:nil];
}


-(void)popDoBack{

    [self dismissViewControllerAnimated:YES completion:nil];

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
