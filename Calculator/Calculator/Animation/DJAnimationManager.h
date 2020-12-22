//
//  DJAnimationManager.h
//  Calculator
//
//  Created by 程青松 on 2020/12/21.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DJAnimationManager : NSObject


+ (instancetype)shardManager;

- (CAEmitterLayer *)animationWithSnow;


@end


