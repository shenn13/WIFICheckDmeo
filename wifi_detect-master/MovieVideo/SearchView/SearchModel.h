//
//  SearchModel.h
//  VideosPlayer
//
//  Created by shen on 16/12/24.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property (nonatomic, strong) NSString *v_name;
@property (nonatomic, strong) NSString *v_note;
@property (nonatomic, strong) NSString *v_id;

@property (nonatomic, strong) NSString *v_pic;
@property (nonatomic, strong) NSString *v_commend;
@property (nonatomic, strong) NSString *v_hit;

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *v_addtime;

@property (nonatomic, strong) NSString *vip;
@property (nonatomic, strong) NSString *appflag;
@property (nonatomic, strong) NSString *daoliuurl;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *tname;
@property (nonatomic, strong) NSString *VIPScore;
@end
