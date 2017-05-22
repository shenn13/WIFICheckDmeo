//
//  MySetting.h
//  MyCenterSetting
//
//  Created by shen on 17/3/3.
//  Copyright © 2017年 shen. All rights reserved.
//

#ifndef MySetting_h
#define MySetting_h



#define MakeColorWithRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//获取屏幕尺寸
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height
#define ScreenBounds     [UIScreen mainScreen].bounds


//功能图片到左边界的距离
#define FuncImgToLeftGap 15

//功能名称字体
#define FuncLabelFont 14

//功能名称到功能图片的距离,当功能图片funcImg不存在时,等于到左边界的距离
#define FuncLabelToFuncImgGap 15

//指示箭头或开关到右边界的距离
#define IndicatorToRightGap 15

//详情文字字体
#define DetailLabelFont 12

//详情到指示箭头或开关的距离
#define DetailViewToIndicatorGap 13



#endif /* MySetting_h */
