//
//  SuggestionsViewController.m
//  MyVideo
//
//  Created by shen on 2017/5/12.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "SuggestionsViewController.h"

@interface SuggestionsViewController (){
    
    UIView *_guangGaoView;
}

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.navigationItem.rightBarButtonItem = nil;
    
    [self SuggestionsClicked];
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
    
-(void)SuggestionsClicked{
    
    _guangGaoView  = [PlayerTool createViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_guangGaoView];
    
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _guangGaoView.height)];
    webView.scalesPageToFit = YES;
    [_guangGaoView addSubview:webView];
    
    NSURL* url = [NSURL URLWithString:@"http://cn.mikecrm.com/wRGG4G8"];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
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
