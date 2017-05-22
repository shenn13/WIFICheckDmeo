//
//  WIFIBaseViewController.m
//  WIFICheck-Dmeo
//
//  Created by shen on 17/3/31.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "WIFIBaseViewController.h"
#import "MovieTabBarViewController.h"

@interface WIFIBaseViewController ()

@end

@implementation WIFIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:kMainScreenColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:246.0/255 alpha:1];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [self customItem];
}

-(void)customItem{
    
    
    [[AFNetworkingManager manager] getDataWithUrl:MarkUrlVideo parameters:nil successBlock:^(id data) {
        if(![[NSString stringWithFormat:@"%@",data[@"data"]]isEqualToString:@"1"] ){
            
        }else{
            
            UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
            [leftButton setTitle:@"秘密通道" forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [leftButton addTarget:self action:@selector(videoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
            self.navigationItem.leftBarButtonItem = leftItem;
            
            srand([[NSDate date] timeIntervalSince1970]);
            float rand=(float)random();
            CFTimeInterval t=rand*0.0000000001;
            [UIView animateWithDuration:0.1 delay:t options:0  animations:^
             {
                 leftButton.transform=CGAffineTransformMakeRotation(-0.05);
             } completion:^(BOOL finished)
             {
                 [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
                  {
                      leftButton.transform=CGAffineTransformMakeRotation(0.05);
                  } completion:^(BOOL finished) {}];
             }];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
    
}

-(void)videoButtonClicked{
    
    MovieTabBarViewController *tabVC = [[MovieTabBarViewController alloc] init];
    [self presentViewController:tabVC animated:YES completion:nil];
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
