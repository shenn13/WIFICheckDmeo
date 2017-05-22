//
//  GGActionSheet.h
//  cicada
//
//  Created by iOSer on 2017/1/9.
//  Copyright © 2017年 iOSer. All rights reserved.
//

/*
    使用规则：必须引入Masnory 因为布局框架是用的它
            实现代理方法即可处理点击事件 点击事件从上到下 index从0开始
            目前可以创建图片类型 以及标题类型
            两种创建方式都根据传入数组的项数决定选项的项数
    创建方式：
            -->图片类型：
                +(instancetype)ActionSheetWithImageArray:(NSArray *)imgArray delegate:(id<GGActionSheetDelegate>)delegate;
 
                说明：
                ImageArray传入图片名字符串
            -->标题类型
                +(instancetype)ActionSheetWithTitleArray:(NSArray *)titleArray  andTitleColorArray:(NSArray *)colors delegate:(id<GGActionSheetDelegate>)delegate;
 
                说明：
                titleArray传入标题字符串
                colors 传入颜色字符串 只允许传入UIColor类型
                titleArray值与colors值一一对应
 
    可设置选项：
            -->cancelDefaultColor（取消按钮默认颜色）:
                如果没有设置，取消按钮默认为黑色
 
            -->optionDefaultColor（标题默认颜色）:
                只在标题类型中有效
                当colors为空时 所有选项标题颜色都为optionDefaultColor传入的颜色
                当colors传入项数少于titleArray项数时，titleArray中的其他标题颜色替换为optionDefaultColor传入的颜色
               *如果没有设置optionDefaultColor 当colors传入项数少于titleArray项数时其他选项颜色默认为黑色
 
 **/
#import <UIKit/UIKit.h>

@protocol GGActionSheetDelegate<NSObject>

-(void)GGActionSheetClickWithIndex:(int)index;

@end

@interface GGActionSheet : UIView
@property(nonatomic,weak) id <GGActionSheetDelegate> delegate;
//默认取消按钮颜色
@property(nonatomic,strong) UIColor *cancelDefaultColor;
//默认选项按钮颜色
@property(nonatomic,strong) UIColor *optionDefaultColor;




//创建标题形式ActionSheet
+(instancetype)ActionSheetWithTitleArray:(NSArray *)titleArray  andTitleColorArray:(NSArray *)colors delegate:(id<GGActionSheetDelegate>)delegate;

//创建图片形式ActionSheet
+(instancetype)ActionSheetWithImageArray:(NSArray *)imgArray delegate:(id<GGActionSheetDelegate>)delegate;

//显示ActionSheet
-(void)showGGActionSheet;



@end
