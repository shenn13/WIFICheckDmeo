//
//  XSMediaPlayer.h
//  MovieDemo
//
//  Created by zhao on 16/3/25.
//  Copyright © 2016年 Mega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void(^BackButtonBlock)(UIButton *button);
typedef void(^EndBolck)();

@interface XSMediaPlayer : UIView

/** 视频URL */
@property (nonatomic, strong) NSURL   *videoURL;
//-(void)orientationChanged:(NSNotification *)noc;

@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *playerItme;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;

/**返回按钮回调方法*/
- (void)backButton:(BackButtonBlock) backButton;

/**播放完成回调*/
- (void)endPlay:(EndBolck) end;

@end



