//
//  EPProgressShow.m
//  ExpressionPackage-Demo
//
//  Created by shen on 17/3/23.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "EPProgressShow.h"

@implementation EPProgressShow

static EPProgressShow *manager = nil;

+ (instancetype)showHUDManager{
    
    if (!manager) {
        manager = [[EPProgressShow alloc] init];
    }
    return manager;
}
-(void)showInfoWithStatus:(NSString *)status{

    [SVProgressHUD showInfoWithStatus:status];
    [SVProgressHUD dismissWithDelay:1.0];
    [SVProgressHUD setBackgroundColor:kMainScreenColor];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];

}

- (void)showErrorWithStatus:(NSString *)status{

    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:1.0];
    [SVProgressHUD setBackgroundColor:kMainScreenColor];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

- (void)showSuccessWithStatus:(NSString *)status{
    
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:1.0];
    [SVProgressHUD setBackgroundColor:kMainScreenColor];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}
@end
