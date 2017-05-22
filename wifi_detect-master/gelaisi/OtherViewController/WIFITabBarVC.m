//
//  WIFITabBarVC.m
//  WIFICheck-Dmeo
//
//  Created by shen on 17/3/31.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "WIFITabBarVC.h"
#import "WIFINavigationVC.h"
#import "UIImage+Extension.h"

@interface WIFITabBarVC ()

@end

@implementation WIFITabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    [self.tabBar setBarTintColor:kMainScreenColor];
    
    [self addSubViewsControllers];
    [self customTabbarItem];
}

-(void)addSubViewsControllers{
    NSArray *classControllers = @[@"TMSearchController",@"WIFILocalMsgVC"];
    NSMutableArray *conArr = [NSMutableArray array];
    
    for (int i = 0; i < classControllers.count; i ++) {
        Class cts = NSClassFromString(classControllers[i]);
        
        UIViewController *vc = [[cts alloc] init];
        WIFINavigationVC *naVC = [[WIFINavigationVC alloc] initWithRootViewController:vc];
        [conArr addObject:naVC];
    }
    self.viewControllers = conArr;
}

-(void)customTabbarItem{
    
    NSArray *titles = @[@"扫描设备",@"本机信息"];
    
    NSArray *normalImages = @[@"tabbar_home_default", @"tabbar_municipios_default"];
        NSArray *selectImages = @[@"tabbar_home_select", @"tabbar_municipios_select"];
    
    for (int i = 0; i < titles.count; i++) {
        
        UIViewController *vc = self.viewControllers[i];
        
        UIImage *normalImage = [UIImage imageWithOriginalImageName:normalImages[i]];
        UIImage *selectImage = [UIImage imageWithOriginalImageName:selectImages[i]];
        
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:normalImage selectedImage:selectImage];
        
    }
    
}


- (BOOL)shouldAutorotate
{
    if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:0]]) {
        
        return [self.selectedViewController shouldAutorotate];
        
    }
    if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:1]]) {
        
        return [self.selectedViewController shouldAutorotate];
        
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:0]]) {
        
        return [self.selectedViewController supportedInterfaceOrientations];
        
    }
    if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:1]]) {
        
        return [self.selectedViewController supportedInterfaceOrientations];
        
    }
    
    return UIInterfaceOrientationMaskPortrait;
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
