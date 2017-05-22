//
//  BaoHistoryManger.h
//  BaoDongHua
//
//  Created by shen on 16/12/16.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchModel;

@interface BaoHistoryManger : NSObject

+ (instancetype)shareManager;

- (BOOL)insertDataWithModel:(SearchModel *)model;

- (BOOL)deleteDataWithID:(NSString *)ID ;
// 查询一条数据是否存在
- (BOOL)searchIsExistWithID:(NSString *)ID;
// 查询所有数据
- (NSArray *)searchAllData;


@end
