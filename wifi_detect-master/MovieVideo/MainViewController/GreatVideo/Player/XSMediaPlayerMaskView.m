//
//  XSMediaPlayerMaskView.m
//  MovieDemo
//
//  Created by zhao on 16/3/25.
//  Copyright © 2016年 Mega. All rights reserved.
//

#import "XSMediaPlayerMaskView.h"
#import <AVFoundation/AVFoundation.h>

@interface XSMediaPlayerMaskView ()

/** bottom渐变层*/
@property (nonatomic, strong) CAGradientLayer *bottomGradientLayer;
/** top渐变层 */
@property (nonatomic, strong) CAGradientLayer *topGradientLayer;
/** bottomView*/
@property (strong, nonatomic  )  UIImageView     *bottomImageView;
/** topView */
@property (strong, nonatomic  )  UIImageView     *topImageView;

@end

@implementation XSMediaPlayerMaskView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topImageView = [[UIImageView alloc]init];
        self.topImageView.userInteractionEnabled = YES;
        
        self.bottomImageView = [[UIImageView alloc]init];

        self.bottomImageView.userInteractionEnabled = YES;
        
    
        self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10,25,25)];
        [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
      
        self.videosNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.videosNameLabel.font = [UIFont systemFontOfSize:16];
        self.videosNameLabel.textColor = [UIColor whiteColor];
        
        self.videosNameLabel.textAlignment = NSTextAlignmentCenter;
    
        self.startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,50,50)];
        [self.startBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.startBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        
        self.fullScreenBtn = [[UIButton alloc]init];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"kr-video-player-fullscreen"] forState:UIControlStateNormal];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"kr-video-player-shrinkscreen"] forState:UIControlStateSelected];
        
        self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10,60, 30)];
        self.currentTimeLabel.text = @"00:00";
        self.currentTimeLabel.textColor = [UIColor whiteColor];
        self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.currentTimeLabel.font = [UIFont systemFontOfSize:15];
        self.totalTimeLabel = [[UILabel alloc]init];
        self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.totalTimeLabel.font = [UIFont systemFontOfSize:15];
        self.totalTimeLabel.textColor = [UIColor whiteColor];
        self.totalTimeLabel.text = @"00:00";
        
    
        self.progressView = [[UIProgressView alloc]init];
        self.progressView.progressTintColor    = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        self.progressView.trackTintColor       = [UIColor clearColor];
    
    
        // 设置slider
        self.videoSlider = [[UISlider alloc]init];
        [self.videoSlider setThumbImage:[UIImage imageNamed:@"slider@2x"] forState:UIControlStateNormal];
        self.videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        self.videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        
        self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [self.topImageView addSubview:self.backBtn];
        [self.topImageView addSubview:self.videosNameLabel];
        
        
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self.bottomImageView addSubview:self.progressView];
        [self.bottomImageView addSubview:self.videoSlider];
        
        [self addSubview:self.activity];
        
        NSError *error;
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
    }
    return self;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.topImageView.frame = CGRectMake(0, 0,width, 50);
    self.bottomImageView.frame = CGRectMake(0,height-50, width, 50);
    
    self.bottomGradientLayer.frame = self.bottomImageView.bounds;
    self.topGradientLayer.frame    = self.topImageView.bounds;
    
    self.videosNameLabel.frame = CGRectMake(CGRectGetMaxX(self.backBtn.frame) + 15, 0, kScreenWidth - CGRectGetMaxX(self.backBtn.frame) - 30, 50);
    
    self.fullScreenBtn.frame = CGRectMake(width - 50,0,50,50);
    
    CGFloat progressWidth = width-2*(self.startBtn.frame.size.width+self.currentTimeLabel.frame.size.width);
    self.progressView.frame = CGRectMake(0,0,progressWidth,20);
    self.progressView.center = CGPointMake(width/2, 25);
    self.totalTimeLabel.frame = CGRectMake(width-110,10,60,30);
    self.videoSlider.frame = self.progressView.frame;
    self.activity.center = CGPointMake(width/2, height/2);
    
}

-(void)dealloc{


}
@end
