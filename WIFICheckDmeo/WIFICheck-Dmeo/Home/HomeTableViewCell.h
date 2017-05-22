//
//  HomeTableViewCell.h
//  WIFICheck-Dmeo
//
//  Created by shen on 17/4/1.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *ipLabel;
@property (strong, nonatomic) UILabel *macAddressLabel;
@property (strong, nonatomic) UILabel *brandLabel;
@property (strong, nonatomic) UILabel *hostnameLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
