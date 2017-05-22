//
//  SearchCollectionViewCell.h
//  VideosPlayer
//
//  Created by shen on 16/12/22.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchModel;

@interface SearchCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)SearchModel *model;

@property (strong, nonatomic) UIImageView *videosImage;

@property (strong, nonatomic) UIImageView *vipView;
@property (strong, nonatomic) UILabel *videosName;


@end
