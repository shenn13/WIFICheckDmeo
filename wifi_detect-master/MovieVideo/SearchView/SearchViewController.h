//
//  SearchViewController.h
//  VideosPlayer
//
//  Created by shen on 16/12/20.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieBaseViewController.h"
@interface SearchViewController : MovieBaseViewController

@property (nonatomic,strong) NSString *searchWord;

@property (nonatomic, assign) BOOL theVideosKey;

@end
