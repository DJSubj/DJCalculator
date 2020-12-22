//
//  NSDate+DJDate.m
//  Calculator
//
//  Created by 程青松 on 2020/12/21.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import "NSDate+DJDate.h"

@implementation NSDate (DJDate)

+ (NSString *)desc {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:NSDate.date];
    return currentDateStr;
}

@end
