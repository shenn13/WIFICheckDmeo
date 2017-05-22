//
//  XSMediaPlayerMaskView.h
//  MovieDemo
//
//  Created by zhao on 16/3/25.
//  Copyright © 2016年 Mega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSMediaPlayerMaskView : UIView


/** 开始播放按钮 */
@property (strong, nonatomic)  UIButton       *startBtn;
/** 当前播放时长label */
@property (strong, nonatomic)  UILabel        *currentTimeLabel;
/** 视频总时长label */
@property (strong, nonatomic)  UILabel        *totalTimeLabel;
/** 缓冲进度条 */
@property (strong, nonatomic)  UIProgressView *progressView;
/** 滑杆 */
@property (strong, nonatomic)  UISlider       *videoSlider;
/** 全屏按钮 */
@property (strong, nonatomic)  UIButton       *fullScreenBtn;

/** 返回按钮 */
@property (strong, nonatomic)  UIButton       *backBtn;
/** 视频label */
@property (strong, nonatomic)  UILabel       *videosNameLabel;

@property (strong, nonatomic)  UIButton       *lockBtn;

/** 系统菊花 */
@property (nonatomic,strong)UIActivityIndicatorView *activity;



@end
