//
//  Api.h
//  MyVideo
//
//  Created by shen on 2017/5/12.
//  Copyright © 2017年 shen. All rights reserved.
//

#ifndef Api_h
#define Api_h

//以iPhone 5的屏幕为基准
#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0


#import "UIImageView+WebCache.h"
#import "PlayerTool.h"
#import "UIView+MJ.h"
#import "AFNetworkingManager.h"
#import "EPProgressShow.h"
#import "BaoHistoryManger.h"
#import "UIImage+Extension.h"

#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "Masonry.h"



//屏蔽好评
#define MarkUrl @"https://api.52kandianying.cn/index.html?method=mark&appid=39&id=58"
//屏蔽视频
#define MarkUrlVideo @"https://api.52kandianying.cn/index.html?method=mark&appid=4&id=76"

//福利片
#define Homeurl @"https://api.52kandianying.cn/index.html?method=typeinfos&id=155"
//电视剧
#define HomeTVURL @"https://api.52kandianying.cn/index.html?method=typeinfos&id=71"
//电影
#define HomeMovieURL @"https://api.52kandianying.cn/index.html?method=typeinfos&id=1"

//详情页面
#define Detailurl @"https://api.52kandianying.cn/index.html?method=videoinfo&"

//关键字热门搜索
#define HotWordurl @"https://api.52kandianying.cn/index.html?method=hotkeys"
//搜索
#define SearchUrl @"https://api.52kandianying.cn/index.html?method=search&keywords="

/*******************
 APP评分跳转链接
 ******************* */
#define APPCommentURL @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1223341722&pageNumber=0&sortOrdering=2&mt=8"

/*******************
 APP下载跳转链接
 ******************* */
#define APPDownURL @"https://itunes.apple.com/cn/app/id1226885234?mt=8"


//APP引流数据
#define JumpToAPPURL @"http://api.52kandianying.cn:81/yinliuapp.html"
//获得设置里的积分
#define ScoreURL  @"https://www.52kandianying.cn/appset.html"
//首页自设弹窗广告链接
#define AdvertisementURL @"http://api.52kandianying.cn:81/index.html?method=app"

#endif /* Api_h */
