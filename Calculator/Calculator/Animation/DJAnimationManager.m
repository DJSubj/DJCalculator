//
//  DJAnimationManager.m
//  Calculator
//
//  Created by 程青松 on 2020/12/21.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import "DJAnimationManager.h"


@interface DJAnimationManager ()
{
    CAEmitterLayer *_snowLayer;
}
@end

@implementation DJAnimationManager

static DJAnimationManager *_manager;
+ (instancetype)shardManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DJAnimationManager alloc] init];
    });
    return _manager;
}



#pragma mark - 动画
/// 雪花动画
- (CAEmitterLayer *)animationWithSnow {
    
    if (_snowLayer) {
        return _snowLayer;
    }
    
    // 创建粒子Layer
    _snowLayer = [CAEmitterLayer layer];
    
    // 粒子发射位置
    _snowLayer.emitterPosition = CGPointMake(kScreenWidth / 2.0,0);
    
    // 发射源的尺寸大小
    _snowLayer.emitterSize = CGSizeMake(kScreenWidth, kScreenHeight);
    
    // 发射模式
    _snowLayer.emitterMode = kCAEmitterLayerSurface;
    
    // 发射源的形状
    _snowLayer.emitterShape = kCAEmitterLayerLine;
    
    // 创建雪花类型的粒子
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    snowflake.contentsScale = 1.5;
    // 粒子的名字
    snowflake.name = @"snow";
    
    // 粒子参数的速度乘数因子
    snowflake.birthRate = 20.0;
    snowflake.lifetime = 10.0;
    
    // 粒子速度
    snowflake.velocity = 10.0;
    
    // 粒子的速度范围
    snowflake.velocityRange = 10;
    
    // 粒子y方向的加速度分量
    snowflake.yAcceleration = 30;
    
    // 周围发射角度
    snowflake.emissionRange = 0.5 * M_PI;
    
    // 子旋转角度范围
    snowflake.spinRange = 0.25 * M_PI;
    snowflake.contents  = (id)[[UIImage imageNamed:@"snow"] CGImage];
    
    // 设置雪花形状的粒子的颜色
    snowflake.color = UIColor.whiteColor.CGColor;
//    snowflake.redRange = 1.5f;
//    snowflake.greenRange = 2.2f;
//    snowflake.blueRange = 2.2f;
    
    snowflake.scaleRange = 0.6f;
    snowflake.scale = 0.7f;
    
    // 添加粒子
    _snowLayer.emitterCells = @[snowflake];
    
    return _snowLayer;
}

@end
