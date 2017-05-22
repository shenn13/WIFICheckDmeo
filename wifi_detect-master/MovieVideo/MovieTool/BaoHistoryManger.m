//
//  BaoHistoryManger.m
//  BaoDongHua
//
//  Created by shen on 16/12/16.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "BaoHistoryManger.h"
#import "SearchModel.h"
#import "FMDatabase.h"


@interface BaoHistoryManger()
{
    FMDatabase          *_fmdb;
    NSLock              *_lock;
}
@end

@implementation BaoHistoryManger

static BaoHistoryManger *manager = nil;
+ (instancetype)shareManager {
    if (!manager) {
        manager = [[BaoHistoryManger alloc] init];
    }
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        manager = [super allocWithZone:zone];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = [[NSLock alloc] init];
        
        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/history.db"];
        
        _fmdb = [FMDatabase databaseWithPath:dbPath];
        
        // 如果数据库没有创建，那么会先创建，然后open
        if ([_fmdb open]) {
            NSString *sql = @"create table if not exists app(appID varchar(50), appIcon varchar(200), appName varchar(1024))";
            BOOL isSuccess = [_fmdb executeUpdate:sql];
            if (isSuccess) {
//                NSLog(@"建表成功");
            } else {
//                NSLog(@"建表失败:%@", _fmdb.lastErrorMessage);
            }
        }
    }
    
    return self;
}

- (BOOL)insertDataWithModel:(SearchModel *)model {
    [_lock lock];
    
    NSString *sql = @"insert into app values(?, ?, ?)";
    
    BOOL isSuccess = [_fmdb executeUpdate:sql, model.v_id, model.v_pic, model.v_name];
    
    if (isSuccess) {
//        NSLog(@"插入数据成功");
    } else {
//        NSLog(@"插入数据失败%@", _fmdb.lastErrorMessage);
    }
    
    [_lock unlock];
    
    return isSuccess;
}

- (BOOL)deleteDataWithID:(NSString *)ID {
    [_lock lock];
    
    NSString *sql = @"delete from app where appID = ?";
    
    BOOL isSuccess = [_fmdb executeUpdate:sql, ID];
    
    
    if (isSuccess) {
//        NSLog(@"插入数据成功");
    } else {
//        NSLog(@"插入数据失败%@", _fmdb.lastErrorMessage);
    }
    
    [_lock unlock];
    
    return isSuccess;
}

- (BOOL)searchIsExistWithID:(NSString *)ID {
    NSString *sql = @"select * from app where appID = ?";
    
    FMResultSet *set = [_fmdb executeQuery:sql, ID];
    
    return [set next];
}

- (NSArray *)searchAllData {
    
    NSString *sql = @"select * from app";
    NSMutableArray *appArr = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    while ([set next]) {
        SearchModel *model = [[SearchModel alloc] init];
        
        model.v_id = [set stringForColumn:@"appID"];
        model.v_pic = [set stringForColumn:@"appIcon"];
        model.v_name = [set stringForColumn:@"appName"];
        
        [appArr addObject:model];
    }
    
    return appArr;
}

@end
