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


- (void)addCalculate:(NSString *)expression result:(NSString *)result;

- (void)deleteCalculate:(NSString *)expression;

- (NSArray *)getAllCalculate;

@end


