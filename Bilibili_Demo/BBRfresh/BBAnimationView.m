//
//  BBAnimationView.m
//  Bilibili_Demo
//
//  Created by 张征鸿 on 2017/8/28.
//  Copyright © 2017年 张征鸿. All rights reserved.
//

#import "BBAnimationView.h"
#import "BBRfreshAnimationLayer.h"
@implementation BBAnimationView

+ (Class)layerClass
{
    return [BBRfreshAnimationLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
