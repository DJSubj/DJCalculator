//
//  DJCalculDataManager.m
//  Calculator
//
//  Created by 程青松 on 2019/11/21.
//  Copyright © 2019 limingbo. All rights reserved.
//

#import "DJCalculDataManager.h"
#import <FMDB/FMDB.h>"
#import "NSDate+DJDate.h"


static DJCalculDataManager *_manager = nil;

@interface DJCalculDataManager ()
{
    FMDatabase *_db;
}
@end

@implementation DJCalculDataManager

+(instancetype)sharedManager{
    if (_manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[DJCalculDataManager alloc] init];
            [_manager initDataBase];
        });
    }
    return _manager;
}

-(void)initDataBase{
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:HISTORY_DATA_PATH];
    
    [_db open];
    
    // 初始化数据表  reply
    NSString *fileSql = @"CREATE TABLE IF NOT EXISTS 'CalculateHistoricalData' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 'calculate_id' VARCHAR(255), 'calculate_expression' VARCHAR(255), 'calculate_result' VARCHAR(255), 'calculate_time' VARCHAR(255))";
    [_db executeUpdate:fileSql];
    
    [_db close];
}




- (void)addCalculate:(NSString *)expression result:(NSString *)result {
    [_db open];
    
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM CalculateHistoricalData "];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"calculate_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"calculate_id"] integerValue] ) ;
        }
    }
    maxID = @([maxID integerValue] + 1);
    
    [_db executeUpdate:@"INSERT INTO CalculateHistoricalData(calculate_id, calculate_expression, calculate_result, calculate_time) VALUES(?, ?, ?, ?)",  maxID, expression, result, NSDate.desc];
    
    
    [_db close];
}

- (void)deleteCalculate:(NSString *)calculateId {
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM CalculateHistoricalData WHERE calculate_id = ?", calculateId];
    
    [_db close];
}

- (NSMutableArray *)getAllCalculate {
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM CalculateHistoricalData ORDER BY calculate_id DESC"];
    while ([res next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[res stringForColumn:@"calculate_expression"] forKey:@"expression"];
        [dic setValue:[res stringForColumn:@"calculate_id"] forKey:@"id"];
        [dic setValue:[res stringForColumn:@"calculate_result"] forKey:@"result"];
        [dataArray addObject:dic];
    }
    
    [_db close];
    
    return dataArray;
}

@end
