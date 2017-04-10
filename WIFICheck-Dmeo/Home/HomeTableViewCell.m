//
//  HomeTableViewCell.m
//  WIFICheck-Dmeo
//
//  Created by shen on 17/4/1.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"HomeCellID";
    HomeTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    [cell addSubviews];

    return cell;
}
-(void)addSubviews{
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 24, 24)];
    [self.contentView addSubview:_image];
    
    _ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 5, W(130), 25)];
    _ipLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_ipLabel];
    
    _macAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, CGRectGetMaxY(_ipLabel.frame) + 5, W(130), 25)];
    _macAddressLabel.font = [UIFont systemFontOfSize:14];

    [self.contentView addSubview:_macAddressLabel];
    
    _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_macAddressLabel.frame)  + 10, 2, kScreenWidth - CGRectGetMaxX(_macAddressLabel.frame) - 20, 60)];
    _brandLabel.numberOfLines = 0;
    _brandLabel.textAlignment = NSTextAlignmentRight;
    _brandLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_brandLabel];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
