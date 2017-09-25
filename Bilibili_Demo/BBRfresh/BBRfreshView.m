//
//  BBRfreshView.m
//  Bilibili_Demo
//
//  Created by 张征鸿 on 2017/8/23.
//  Copyright © 2017年 张征鸿. All rights reserved.
//

#import "BBRfreshView.h"
#import "BBAnimationView.h"
@interface BBRfreshView ()<UIScrollViewDelegate>

@property (nullable, weak, nonatomic) UIScrollView *scrollView;

@property (nullable, strong, nonatomic) BBAnimationView *animationView; //承载动画layer
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
static NSString * const bb_observer_contentOffset = @"contentOffset";
- (void)showFromScrollView:(UIScrollView *)scrollView
{
    NSParameterAssert([scrollView isKindOfClass:[UITableView class]]);
    _scrollView = scrollView;
    _scrollView.delegate = self;
    [scrollView.superview insertSubview:self belowSubview:scrollView];
    [_scrollView addObserver:self forKeyPath:bb_observer_contentOffset options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - ScrollView Delegate
static bool beyondCrucial = false;
static float pullOffsetY_showView = 50; //下拉多少出现动画层

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:bb_observer_contentOffset]) {
        CGPoint offset = [(NSValue *)change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat offset_y = offset.y;
        
        if (willDraggingEnd && _scrollView.contentOffset.y > -pullOffsetY_showView) {
            return;
        }
        if (offset_y < -pullOffsetY_showView) {
            _showView.top = fabs(_scrollView.contentOffset.y) - pullOffsetY_showView;
            
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
            [_animationLayer positionAnimation:position];
        }
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

- (BBAnimationView *)animationView
{
    if (!_animationView) {
        _animationView = [BBAnimationView new];
        if ([_animationView.layer isKindOfClass:[BBRfreshAnimationLayer class]]) {
            _animationLayer = (BBRfreshAnimationLayer *)_animationView.layer;
        }
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
    [self removeObserver:self forKeyPath:bb_observer_contentOffset];
}

@end
