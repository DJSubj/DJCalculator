//
//  DJCalculator.m
//  Calculator
//
//  Created by 程青松 on 2020/12/14.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import "DJCalculator.h"
#import "DJStack.h"

@implementation DJCalculator


+ (NSString *)calculator:(NSString *)string {
//    string = @"(5.8-3)/2^2*3√27+12-(+2+3.1)*(2+5)";
    NSLog(@"%@", string);
    if (!string.length) {
        return @"";
    }
    NSArray *arr = [self splitString:string];
//    NSLog(@"%@", arr);
    NSArray *bolanArr = [self expresConversion:arr];
//    NSLog(@"%@", bolanArr);
    NSString *result = [self calculateExpresArray:bolanArr];
    NSLog(@"%@", result);
    
    NSInteger cutIndex = result.length;
    for (NSInteger i = result.length; i > 0; i--) {
        NSString *subStr = [result substringWithRange:NSMakeRange(i - 1, 1)];
        if (![subStr isEqualToString:@"0"]) {
            if ([subStr isEqualToString:@"."]) {
                cutIndex = i - 1;
            } else {
                cutIndex = i;
            }
            break;
        }
    }
    
    return [result substringToIndex:cutIndex];
}

#pragma mark - 字符串分离
/// 待计算字符串分析，分离出数字与运算符
+ (NSArray *)splitString:(NSString *)string {
    
    NSMutableArray *arr = NSMutableArray.new;
    
    NSMutableString *str = @"".mutableCopy;
    NSString *pre = @"";
    
    for (int i = 0; i < string.length; i++) {
        
        NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([self isDigitOrDot:subStr]) {
            [str appendString:subStr];
            pre = subStr;
        } else if ([self isSymbol:subStr]) {
            if (str.length) {
                [arr addObject:str];
                str = @"".mutableCopy;
            }
            
            if([self isSign:subStr] && (([pre isEqualToString:@""]) || ([pre isEqualToString:@"("]) || [self isOperator:pre])) {
                [str appendString:subStr];
            } else {
                [arr addObject:subStr];
            }

            pre = subStr;
        }
        
    }
    
    if (str.length) {
        [arr addObject:str];
    }
    
    return arr;
}


#pragma mark - 表达式转换
/// 中缀表达式转换为后缀表达式
+ (NSArray *)expresConversion:(NSArray *)array {
    
    NSMutableArray *arr = NSMutableArray.array; // 转换结果容器
    DJStack<NSString *> *stack = DJStack.stack; //操作符的容器
    
    for (int i = 0; i < array.count; i++) {
        NSString *element = array[i];
        if ([self isNumber:element]) {
            [arr addObject:element];
        } else if ([self isOperator:element]) {
            //如果当前元素的优先级小于栈顶元素的优先级，那么输出栈顶元素。
            while(!stack.isEmpty && ([self priority:element] <= [self priority:stack.top])) {
                [arr addObject:stack.pop];
            }
            [stack push:element];
        } else if ([self isLeft:element]) {
            [stack push:element];
        } else if ([self isRight:element]) {
            //如果栈顶元素不是左括号，输出保存
            while(!stack.isEmpty && ![self isLeft:stack.top]) {
                [arr addObject:stack.pop];
            }
            if(!stack.isEmpty) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-getter-return-value"
                //将栈顶的左括号弹出去不要了。
                stack.pop;
#pragma clang diagnostic pop
            }
        } else {
            
            NSLog(@"xxxx");
        }
    }
    
    //中缀转后缀的操作，将括号不要了。但是其他的一个都不能缺少。因此遍历栈中的元素。
    while(!stack.isEmpty) {
        [arr addObject:stack.pop];
    }
//    //转换失败，将输出队列清空。
//    if(!ret) {
//        output.clear();
//    }
    
    
    return arr;
}


#pragma mark - 计算
/// 后缀表达式计算
+ (NSString *)calculateExpresArray:(NSArray *)array {
    DJStack *stack = DJStack.stack;
    for (int i = 0; i < array.count; i++) {
        NSString *element = array[i];
        if ([self isNumber:element]) {
            [stack push:element];
        } else if ([self isOperator:element]) {
            NSString *right = !stack.isEmpty ? stack.pop : @"";
            NSString *left = !stack.isEmpty ? stack.pop : @"";
            NSString *result = [self calculateWithLeft:left right:right operator:element];
            if(![result isEqualToString:@"Error"]) {
                [stack push:result];
            } else {
                return @"Error";
            }
        } else {
            return @"Error";
        }
    }
    // 数组中的数据被遍历完；栈中仅有一个元素，这个元素就是运算结果；并且栈中的这个元素是数字
    if((stack.size == 1) && [self isNumber:stack.top]) {
        return stack.pop;
    }
    return @"Error";
}


#pragma mark -
/// 单次计算
+ (NSString *)calculateWithLeft:(NSString *)left right:(NSString *)right operator:(NSString *)operator {
    NSString *ret = @"Error";

    if([self isNumber:left] && [self isNumber:right])
    {
        double left_d = left.doubleValue;
        double right_d = right.doubleValue;

        if([operator isEqualToString:@"+"]) {
            //直接进行运算，并将结果转换成字符串。
            ret = [NSString stringWithFormat:@"%f", left_d + right_d];
        } else if([operator isEqualToString:@"-"]) {
            ret = [NSString stringWithFormat:@"%f", left_d - right_d];
        } else if([operator isEqualToString:@"*"]) {
            ret = [NSString stringWithFormat:@"%f", left_d * right_d];
        } else if([operator isEqualToString:@"/"]) {
            const double P = 0.000000000000001;
            if((-P < right_d) && (right_d < P)) {
                ret = @"Error";
            } else {
                ret = [NSString stringWithFormat:@"%f", left_d / right_d];
            }
        } else if([operator isEqualToString:@"%"]) {
            const double P = 0.000000000000001;
            if((-P < right_d) && (right_d < P)) {
                ret = @"Error";
            } else {
                ret = [NSString stringWithFormat:@"%d", (int)left_d % (int)right_d];
            }
        } else if([operator isEqualToString:@"^"]) {
            ret = [NSString stringWithFormat:@"%f", pow(left_d, right_d)];
        } else if([operator isEqualToString:@"√"]) {
            ret = [NSString stringWithFormat:@"%f", pow(right_d, (1.0 / left_d))];
        } else {
            ret = @"Error";
        }
    }
    NSLog(@"%@%@%@=%@", left, operator, right, ret);
    return ret;
}

/// 判断数组括号是否匹配
+ (BOOL)bracketsMatch:(NSArray *)array {
    BOOL ret = YES;
    NSInteger len = array.count;
    DJStack<NSString *> *stack = DJStack.stack;
    
    for(int i = 0; i < len; i++) {
        NSString *element = array[i];
        if([self isLeft:element]) {
            [stack push:element];
        } else if([self isRight:element]) {
            if(!stack.isEmpty && [self isLeft:stack.top]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-getter-return-value"
                //遇到一个右括号就会将左括号弹出栈。
                stack.pop;
#pragma clang diagnostic pop
            } else {
                ret = NO;
                break;
            }
        }
    }
    
    //因为在上面的程序中遇到一个右括号就会将左括号弹出栈，如果左右括号完全匹配的话，最后栈中是没有括号的，即为空。
    //就是为了处理"-9.11+ (3 - (-1)* -5" 左括号比右括号多的问题。
    if(!stack.isEmpty) {
        ret = NO;
    }

    return ret;
}


/// 是否是数字或小数
+ (BOOL)isDigitOrDot:(NSString *)str {
    NSArray *arr = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"."];
    return [arr containsObject:str];
}

/// 是否是操作符
+ (BOOL)isOperator:(NSString *)str {
    NSArray *arr = @[@"+", @"-", @"*", @"/", @"%", @"^", @"√"];
    return [arr containsObject:str];
}

+ (NSInteger)priority:(NSString *)str {
    int ret = 0;
    if([str isEqualToString:@"+"] || [str isEqualToString:@"-"]) {
        ret = 1;
    }
    if([str isEqualToString:@"*"] || [str isEqualToString:@"/"] || [str isEqualToString:@"%"]) {
        ret = 2;
    }
    if([str isEqualToString:@"^"] || [str isEqualToString:@"√"]) {
        ret = 3;
    }
    return ret;
}

/// 是否是符号
+ (BOOL)isSymbol:(NSString *)str {
    return [self isOperator:str] || [str isEqualToString:@"("] || [str isEqualToString:@")"];
}

/// 是否是正负号
+ (BOOL)isSign:(NSString *)str {
    return [str isEqualToString:@"+"] || [str isEqualToString:@"-"];
}

+ (BOOL)isNumber:(NSString *)str {
    NSScanner* scan = [NSScanner scannerWithString:str];
    double val;
    return [scan scanDouble:&val] && [scan isAtEnd];
}

/// 是否是左括号
+ (BOOL)isLeft:(NSString *)str {
    return [str isEqualToString:@"("];
}

/// 是否是右括号
+ (BOOL)isRight:(NSString *)str {
    return [str isEqualToString:@")"];
}

@end
