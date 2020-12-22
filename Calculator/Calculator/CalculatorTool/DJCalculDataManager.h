//
//  DJCalculDataManager.h
//  Calculator
//
//  Created by 程青松 on 2019/11/21.
//  Copyright © 2019 limingbo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DJCalculDataManager : NSObject

+ (instancetype)sharedManager;

/// 添加计算记录到数据库
- (void)addCalculate:(NSString *)expression result:(NSString *)result;

/// 删除记录
- (void)deleteCalculate:(NSString *)expression;

/// 计算记录列表
- (NSArray *)getAllCalculate;

@end


