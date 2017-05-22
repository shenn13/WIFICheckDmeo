//
//  MovieNagationViewController.m
//  MyVideo
//
//  Created by shen on 17/4/11.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "MovieNagationViewController.h"

@interface MovieNagationViewController ()

@end

@implementation MovieNagationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //导航栏
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 10, 19);
    [setBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(popToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

    
- (void)popToBack{
    
    [self popViewControllerAnimated:YES];
}
    
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
    {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        [super pushViewController:viewController animated:animated];
        
    }
    
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}

- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[UIViewController class]]) {
        
        return [self.topViewController shouldAutorotate];
    }
    return NO; // VideoViewController自动旋转交给改控制器自己控制，其他控制器则不支撑自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[UIViewController class]]) {
        
        return [self.topViewController supportedInterfaceOrientations];
        
    } else {
        return UIInterfaceOrientationMaskPortrait; //VideoViewController所支持旋转交给改控制器自己处理，其他控制器则只支持竖屏
    }
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
