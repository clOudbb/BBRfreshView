//
//  BBRfreshView.h
//  Bilibili_Demo
//
//  Created by 张征鸿 on 2017/8/23.
//  Copyright © 2017年 张征鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBRfreshAnimationLayer.h"
@interface BBRfreshView : UIView


@property (nullable, strong, nonatomic) UIView *showView;

NS_ASSUME_NONNULL_BEGIN
- (void)showFromScrollView:(UIScrollView *)scrollView;
NS_ASSUME_NONNULL_END
@end
