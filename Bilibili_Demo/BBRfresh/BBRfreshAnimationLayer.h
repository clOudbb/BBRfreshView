//
//  BBRfreshAnimationLayer.h
//  Bilibili_Demo
//
//  Created by 张征鸿 on 2017/8/23.
//  Copyright © 2017年 张征鸿. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

static float const bb_earHeight = 10;
static float const bb_earWidth = 35;
static float const bb_earSpace = 50;
@interface BBRfreshAnimationLayer : CALayer

@property (nullable, strong, nonatomic) CAShapeLayer *leftEar;
@property (nullable, strong, nonatomic) CAShapeLayer *rightEar;


- (void)positionAnimation:(CGFloat)position;
@end
