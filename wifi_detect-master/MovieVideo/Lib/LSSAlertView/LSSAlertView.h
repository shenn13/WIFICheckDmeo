//
//  LSSAlertView.h
//  LSSAlertView
//
//  Created by MS on 16/5/11.
//  Copyright © 2016年 LSS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^alertReturn)(NSInteger index);

@interface LSSAlertView : UIView

@property (nonatomic,copy) alertReturn returnIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureBtn cancleBtn:(NSString *)cancleBtn;
- (void)showAlertView;
@end
