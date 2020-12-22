//
//  DJStack.m
//  Calculator
//
//  Created by 程青松 on 2020/12/15.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import "DJStack.h"

@interface DJStack ()

@property(nonatomic, strong) NSMutableArray *elementArray;

@end

@implementation DJStack

+ (instancetype)stack {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.elementArray = NSMutableArray.array;
    }
    return self;
}

- (NSInteger)size {
    return self.elementArray.count;
}

- (BOOL)isEmpty {
    return self.size == 0;
}


/// 向栈内添加元素
- (void)push:(id)e {
    [self.elementArray addObject:e];
}

/// 弹出栈顶元素
- (id)pop {
    id e = [self top];
    [self.elementArray removeObjectAtIndex:(self.size - 1)];
    return e;
}

/// 查看栈顶元素
- (id)top {
    return [self.elementArray objectAtIndex:(self.size - 1)];
}

/// 清空栈
- (void)clear {
    [self.elementArray removeAllObjects];
}

@end
