//
//  DJSettingVC.h
//  Calculator
//
//  Created by 程青松 on 2020/12/17.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DJSettingVC : UIViewController

/// 选择图片
@property(nonatomic, copy) void(^selectImageBlock)(UIImage *img);

/// 设置背景动画
@property(nonatomic, copy) void(^bgAnimationBlock)(BOOL bgAnimation);

@end


