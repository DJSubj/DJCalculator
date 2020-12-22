//
//  UIColor+DJColor.m
//  Calculator
//
//  Created by 程青松 on 2020/12/16.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import "UIColor+DJColor.h"

@implementation UIColor (DJColor)


+ (UIColor *)textColor {
    return UIColor.whiteColor;
}

+ (UIColor *)translucentColor {
    return [UIColor colorWithWhite:0 alpha:0.3];
}


@end
