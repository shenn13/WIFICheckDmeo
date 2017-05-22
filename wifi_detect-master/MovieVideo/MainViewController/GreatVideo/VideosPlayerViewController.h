//
//  VideosPlayerViewController.h
//  VideosPlayer
//
//  Created by shen on 16/12/21.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieBaseViewController.h"
#import "GDTMobInterstitial.h"

@interface VideosPlayerViewController : MovieBaseViewController<GDTMobInterstitialDelegate>{
     GDTMobInterstitial *_interstitialObj;
}

@property (nonatomic,strong) NSString *v_id;
@property (nonatomic,strong) NSString *videoIndexTag;


@property(nonatomic ,assign)BOOL isPresent;

@end
