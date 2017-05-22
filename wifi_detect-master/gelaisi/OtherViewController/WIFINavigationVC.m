//
//  WIFINavigationVC.m
//  WIFICheck-Dmeo
//
//  Created by shen on 17/3/31.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "WIFINavigationVC.h"
#import "VideosPlayerViewController.h"
@interface WIFINavigationVC ()

@end

@implementation WIFINavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[VideosPlayerViewController class]]) {
        
        return [self.topViewController shouldAutorotate];
    }
    return NO; // VideoViewController自动旋转交给改控制器自己控制，其他控制器则不支撑自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[VideosPlayerViewController class]]) {
        
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
