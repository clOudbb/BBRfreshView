//
//  BBRfreshView.m
//  Bilibili_Demo
//
//  Created by 张征鸿 on 2017/8/23.
//  Copyright © 2017年 张征鸿. All rights reserved.
//

#import "BBRfreshView.h"

@interface BBRfreshView ()<UIScrollViewDelegate>

@property (nullable, strong, nonatomic) UIScrollView *scrollView;

@property (nullable, strong, nonatomic) UIView *animationView; //承载动画layer
@property (nullable, strong, nonatomic) BBRfreshAnimationLayer *animationLayer;
@end

@implementation BBRfreshView

#pragma mark - instancetype

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.showView];
        [self addSubview:self.animationView];
    }
    return self;
}

static bool layoutBool = false;
static float const bb_animationViewHeight = 100;
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!layoutBool) {
        _showView.frame = self.bounds;
        _animationView.frame = (CGRect){0, -bb_animationViewHeight, self.bounds.size.width, bb_animationViewHeight + bb_earHeight};
        if (_animationLayer) {
            _animationLayer.frame = _animationView.bounds;
        }
        layoutBool = !layoutBool;
        [self bringSubviewToFront:_showView];
    }
}

#pragma mark - Public Method

- (void)showFromScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.delegate = self;
    [scrollView.superview insertSubview:self belowSubview:scrollView];
}

#pragma mark - ScrollView Delegate
static bool beyondCrucial = false;
static float pullOffsetY_showView = 50; //下拉多少出现动画层
/**
 * 这里在tableView回弹时 监听不够精确，导致回弹时动画不会回到起始点
 * 暂时在回弹结束时主动将动画回归起始位置
 * 可以考虑用KVO监听(性能消耗大，频率高)
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (willDraggingEnd) {
        return;
    }
    if (scrollView.contentOffset.y < -pullOffsetY_showView) {
        if ([scrollView isKindOfClass:[UITableView class]]) {
            _showView.top = fabs(_scrollView.contentOffset.y) - pullOffsetY_showView;
            NSLog(@"%.2f", _showView.top);
        }
        if (!beyondCrucial) {
            beyondCrucial = true;
        }
    } else {
        if (beyondCrucial) {
            if (_showView.top < 0) {
                _showView.top = 0;
                beyondCrucial = !beyondCrucial;
            } else {
                _showView.top = fabs(_scrollView.contentOffset.y) - pullOffsetY_showView;
            }
        }
    }
    _animationView.bottom = _showView.top + bb_earHeight;
    if (_scrollView.contentOffset.y <= -pullOffsetY_showView) {
        CGFloat position = fabs(_scrollView.contentOffset.y + pullOffsetY_showView) / 100;
        NSLog(@"position = %f", position);
        [_animationLayer positionAnimation:position];
    }
}

static bool willDraggingEnd = false;  //拖拽是否结束
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    willDraggingEnd = true;
    [_animationLayer positionAnimation:0];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    willDraggingEnd = false;
}

#pragma mark - Get
- (UIView *)showView
{
    if (!_showView) {
        _showView = [UIView new];
    }
    return _showView;
}

- (UIView *)animationView
{
    if (!_animationView) {
        _animationView = [UIView new];
        self.animationLayer = [BBRfreshAnimationLayer layer];
        [_animationView.layer insertSublayer:_animationLayer atIndex:0];
    }
    return _animationView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    _scrollView.delegate = nil;
}

@end
