//
//  SearchCollectionViewCell.m
//  VideosPlayer
//
//  Created by shen on 16/12/22.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import "SearchModel.h"

@interface SearchCollectionViewCell(){
    
}
@end

@implementation SearchCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        
       [self addSubviews];
        
    }else{
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
    }

    
    return self;
}

-(void)addSubviews{
    
    _videosImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height - H(30))];
    [self.contentView addSubview:_videosImage];
    
    
    _vipView = [PlayerTool createImageViewWithFrame:CGRectMake(_videosImage.width - W(25), 0, W(25), H(15)) ImageName:@""];
    [self.contentView addSubview:_vipView];
    
    
    _videosName = [PlayerTool createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(_videosImage.frame) + 10,self.contentView.width , H(20)) Font:H(12) Text:@""];
    _videosName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_videosName];

}

-(void)setModel:(SearchModel *)model{
    _model = model;
    
    [_videosImage sd_setImageWithURL:[NSURL URLWithString:model.v_pic] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    if ([model.vip isEqualToString:@"vip"]) {
        
        _vipView.image = [UIImage imageNamed:@"vip.png"];
        
    }else{
        
        _vipView.image = [UIImage imageNamed:@""];
    }
    
    
    _videosName.text = model.v_name;
    
    
}



- (void)prepareForReuse{
    [super prepareForReuse];
  
}

@end
