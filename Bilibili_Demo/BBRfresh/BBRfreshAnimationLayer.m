//
//  BBRfreshAnimationLayer.m
//  Bilibili_Demo
//
//  Created by 张征鸿 on 2017/8/23.
//  Copyright © 2017年 张征鸿. All rights reserved.
//

#import "BBRfreshAnimationLayer.h"

static NSString * const kWaveLayerAnimation = @"kWaveLayerAnimation";
@interface BBRfreshAnimationLayer ()

@property (nullable, strong, nonatomic) CAShapeLayer *waveLayer;
@property (nullable, strong, nonatomic) CAShapeLayer *waveLayerSecond;

@end

@implementation BBRfreshAnimationLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self leftEarLayer];
        [self rightEarLayer];
    }
    return self;
}

static bool layoutBool = false;
- (void)layoutSublayers
{
    [super layoutSublayers];
    if (!layoutBool) {
        _leftEar.left = self.centerX - bb_earSpace;
        _rightEar.right = self.centerX + bb_earSpace;
        _leftEar.bottom = self.height;
        _rightEar.bottom = _leftEar.bottom;
        layoutBool = !layoutBool;
    }
}

#pragma mark - Public Method
- (void)start
{
    
}
#pragma mark - Animation
/** 电波 */
- (void)waveAnimation
{
    for (int i = 0; i < 2; i++) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.size = CGSizeMake(100, 40);
        layer.cornerRadius = 20;
        //    layer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(layer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
        layer.path = path.CGPath;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor grayColor].CGColor;
        //    layer.lineWidth = 4;
        //    layer.lineCap = kCALineCapRound;
        //    layer.strokeStart = 0;
        //    layer.strokeEnd = 0;
        [self addSublayer:layer];
        layer.centerX = self.centerX;
        layer.centerY = self.height -  _leftEar.height;
        if (i == 0) { _waveLayer = layer; }
        else { _waveLayerSecond = layer; _waveLayerSecond.hidden = true;}
    }
    
    _group = [self _waveAnimation];
    [_waveLayer addAnimation:_group forKey:@"group"];
    [_group setValue:kWaveLayerAnimation forKey:kWaveLayerAnimation];
    if ([self respondsToSelector:@selector(secondWave)]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(secondWave) object:nil];
        [self performSelector:@selector(secondWave) withObject:nil afterDelay:0.4 inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)secondWave
{
    CAAnimationGroup *group = [self _waveAnimation];
    _waveLayerSecond.hidden = false;
    [_waveLayerSecond addAnimation:group forKey:@"groupSecnod"];
}

static CAAnimationGroup *_group;
- (CAAnimationGroup *)_waveAnimation
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.values = @[@1, @0.6, @0.4, @0.2, @0, @0];
    opacity.keyTimes = @[@0, @0.1,@0.3, @0.4, @0.6, @1];
    opacity.duration = 1.5;
    
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@0.7, @1,@1.3, @1.5, @1.7, @1.7];
    scale.keyTimes = @[@0, @0.15, @0.3, @0.45, @0.6,  @1];
    scale.duration = 1.5;
    
    group.animations = @[opacity, scale];
    group.repeatCount = NSIntegerMax;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = true;
    group.duration = 1.5;
    group.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    return group;
}

- (void)removeWaveAnimation
{
    if (_waveLayer) {
        [_waveLayer removeAllAnimations];
        [_waveLayer removeFromSuperlayer];
    }
    if (_waveLayerSecond) {
        [_waveLayerSecond removeAllAnimations];
        [_waveLayerSecond removeFromSuperlayer];
    }
}

/** 抖动 */
- (void)shakeAnimation
{
    CAKeyframeAnimation *leftShake = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    leftShake.values = @[@(M_PI_2 / 1.6), @(M_PI_2),@(M_PI_2 / 1.6),
                         @(M_PI_2),@(M_PI_2 / 1.6), @(M_PI_2 / 1.6)];
    leftShake.keyTimes = @[@0, @0.15, @0.3, @0.45, @0.6,  @1];
    leftShake.duration = 1.5;
    leftShake.repeatCount = NSIntegerMax;
    [_leftEar addAnimation:leftShake forKey:@"leftShake"];
    
    CAKeyframeAnimation *rightShake = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rightShake.values = @[@(-M_PI_2 / 1.6), @(-M_PI_2),@(-M_PI_2 / 1.6),
                         @(-M_PI_2),@(-M_PI_2 / 1.6), @(-M_PI_2 / 1.6)];
    rightShake.keyTimes = @[@0, @0.15, @0.3, @0.45, @0.6,  @1];
    rightShake.duration = 1.5;
    rightShake.repeatCount = NSIntegerMax;
    [_rightEar addAnimation:rightShake forKey:@"rightShake"];
}
#pragma mark - Layer
- (void)leftEarLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.size = CGSizeMake(bb_earWidth, bb_earHeight);
    layer.cornerRadius = 5;
    layer.backgroundColor = [UIColor grayColor].CGColor;
    [self addSublayer:layer];
    layer.anchorPoint = (CGPoint){1, 0.5};
    _leftEar = layer;
}

- (void)rightEarLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.size = CGSizeMake(bb_earWidth, bb_earHeight);
    layer.cornerRadius = 5;
    layer.backgroundColor = [UIColor grayColor].CGColor;
    [self addSublayer:layer];
    layer.anchorPoint = (CGPoint){0, 0.5};
    _rightEar = layer;
}

#pragma mark - position
static float move = 0;
static bool waveOpen = false;
- (void)positionAnimation:(CGFloat)position
{
    [CATransaction begin];
    [CATransaction setDisableActions:true];
    if (position > 0.6) {
//        move = move + (position - move) / 10;
        if (!waveOpen) {
            [self waveAnimation];
            [self shakeAnimation];
            waveOpen = !waveOpen;
        }
    } else {
        if (waveOpen && _waveLayer) {
            [self removeWaveAnimation];
            [_leftEar removeAllAnimations];
            [_rightEar removeAllAnimations];
            waveOpen = !waveOpen;
        }
        move = position;
    }
    [CATransaction commit];
    _leftEar.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI_4 * 2 * move));
    _rightEar.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(-M_PI_4 * 2* move));
}

- (void)dealloc
{
    
}

@end
