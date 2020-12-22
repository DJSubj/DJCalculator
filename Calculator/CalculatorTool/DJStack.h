//
//  DJStack.h
//  Calculator
//
//  Created by 程青松 on 2020/12/15.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DJStack<ObjectType> : NSObject


/// 初始化
+ (instancetype)stack;

/// 栈空间大小
@property(nonatomic, assign, readonly) NSInteger size;

/// 栈是否为空
@property(nonatomic, assign, readonly) BOOL isEmpty;

/// 向栈内添加元素
- (void)push:(ObjectType)e;

/// 弹出栈顶元素
- (ObjectType)pop;

/// 查看栈顶元素
- (ObjectType)top;

/// 清空栈
- (void)clear;

@end


