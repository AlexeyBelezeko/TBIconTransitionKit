//
// TBAnimationButton.m
// AnimatedButtonTransition
//
// Created by AlexeyBelezeko on 07/15/2015.
// Copyright (c) 2015 AlexeyBelezeko. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TBAnimationButton.h"

@interface TBAnimationButton ()
{
    CAShapeLayer *_topLayer;
    CAShapeLayer *_middleLayer;
    CAShapeLayer *_bottomLayer;
    CGRect _lastBounds;
}

@end


//Constants for animation and shapes
static CGFloat tbScaleForArrow = 0.7;
static NSString *tbAnimationKey = @"tbAnimationKey";
static CGFloat tbFrameRate = 1.0/30.0;
static CGFloat tbAnimationFrames = 10.0;

@implementation TBAnimationButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self commonInit];
    return self;
}

//Default configuration
- (void)commonInit
{
    self.lineColor = [UIColor whiteColor];
    self.lineHeight = 2.0;
    self.lineSpacing = 8.0;
    self.lineWidth = 30.0;
    self.lineCap = TBAnimationButtonLineCapRound;
    self.currentState = TBAnimationButtonStatePlus;
    [self updateAppearance];
}

//Update shapes
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(_lastBounds, self.bounds)) {
        [self updateAppearance];
    }
}

- (void)updateAppearance
{
    _lastBounds = self.bounds;
    [_topLayer removeFromSuperlayer];
    [_middleLayer removeFromSuperlayer];
    [_bottomLayer removeFromSuperlayer];
    
    CGFloat x = CGRectGetWidth(self.bounds) / 2.0;
    CGFloat heightDiff = self.lineHeight + self.lineSpacing;
    CGFloat y = CGRectGetHeight(self.bounds) / 2.0 - heightDiff;
    
    _topLayer = [self createLayer];
    _topLayer.position = CGPointMake(x , y);
    y += heightDiff;
    
    _middleLayer = [self createLayer];
    _middleLayer.position = CGPointMake(x , y);
    y += heightDiff;
    
    _bottomLayer = [self createLayer];
    _bottomLayer.position = CGPointMake(x , y);
    [self transformToState:_currentState];
}

- (void)setCurrentState:(TBAnimationButtonState)currentState
{
    [self transformToState:currentState];
}

- (void)transformToState:(TBAnimationButtonState)state
{
    CATransform3D transform;
    switch (state) {
        case TBAnimationButtonStateArrow:{
            _topLayer.transform = [self arrowLineTransform:_topLayer];
            _middleLayer.transform = [self arrowLineTransform:_middleLayer];
            _bottomLayer.transform = [self arrowLineTransform:_bottomLayer];
        }break;
        case TBAnimationButtonStateCross:{
            transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_topLayer.position.y, 0.0);
            _topLayer.transform = CATransform3DRotate(transform, M_PI_4, 0.0, 0.0, 1.0);
            _middleLayer.transform = CATransform3DMakeScale(0., 0., 0.);
            transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_bottomLayer.position.y, 0.0);
            _bottomLayer.transform = CATransform3DRotate(transform, -M_PI_4, 0.0, 0.0, 1.0);
        }break;
        case TBAnimationButtonStateMinus:{
            _topLayer.transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_topLayer.position.y, 0.0);
            _middleLayer.transform = CATransform3DMakeScale(0., 0., 0.);
            _bottomLayer.transform = CATransform3DMakeScale(0., 0., 0.);
        }break;
        case TBAnimationButtonStatePlus:{
            transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_topLayer.position.y, 0.0);
            _topLayer.transform = transform;
            _middleLayer.transform = CATransform3DMakeScale(0., 0., 0.);
            transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_bottomLayer.position.y, 0.0);
            _bottomLayer.transform = CATransform3DRotate(transform, -M_PI_2, 0.0, 0.0, 1.0);
        }break;
        default:{
            //Default state is menu
            _topLayer.transform = CATransform3DIdentity;
            _middleLayer.transform = CATransform3DIdentity;
            _bottomLayer.transform = CATransform3DIdentity;
        }break;
    }
    _currentState = state;
}

- (CATransform3D)arrowLineTransform:(CALayer *)line
{
    CATransform3D transform;
    if (line == _middleLayer) {
        CGFloat middleLineXScale = self.lineHeight/self.lineWidth;
        transform = CATransform3DMakeScale(1.0 - middleLineXScale, 1.0, 1.0);
        transform = CATransform3DTranslate(transform, self.lineWidth*middleLineXScale/2.0, 0.0, 0.0);
        return transform;
    }
    CGFloat lineMult = line == _topLayer ? 1.0 : -1.0;
    CGFloat yShift = 0.0;
    if (self.lineCap == TBAnimationButtonLineCapButt) {
        yShift = sqrt(2)*self.lineHeight/4.;
    }
    CGFloat lineShift = self.lineWidth * (1.-tbScaleForArrow)/2.;
    transform = CATransform3DMakeTranslation(-lineShift, _middleLayer.position.y-line.position.y + yShift * lineMult, 0.0);
    CGFloat xTransform = self.lineWidth/2. - lineShift;
    transform = CATransform3DTranslate(transform, -xTransform, 0 , 0.0);
    transform = CATransform3DRotate(transform, M_PI_4 * lineMult, 0.0, 0.0, -1.0);
    transform = CATransform3DTranslate(transform, xTransform, 0, 0.0);
    transform = CATransform3DScale(transform, tbScaleForArrow, 1., 1.);
    return transform;
}

- (void)animationTransformToState:(TBAnimationButtonState)state
{
    if (_currentState == state) {
        return;
    }
    BOOL findAnimationForTransition = NO;
    switch (_currentState) {
        case TBAnimationButtonStateArrow:{
            if (state == TBAnimationButtonStateMenu) {
                findAnimationForTransition = YES;
                [self animationTransitionFromMenuToArrow:YES];
            }
        }break;
        case TBAnimationButtonStateCross:{
            if (state == TBAnimationButtonStateMenu) {
                findAnimationForTransition = YES;
                [self animationTransitionFromMenuToCross:YES];
            } else if (state == TBAnimationButtonStatePlus) {
                findAnimationForTransition = YES;
                [self animationTransitionFromCrossToPlus:NO];
            }
        }break;
        case TBAnimationButtonStateMinus:{
            if (state == TBAnimationButtonStatePlus) {
                findAnimationForTransition = YES;
                [self animationTransitionFromPLusToMinus:YES];
            }
        }break;
        case TBAnimationButtonStatePlus:{
            if (state == TBAnimationButtonStateCross) {
                findAnimationForTransition = YES;
                [self animationTransitionFromCrossToPlus:YES];
            } if (state == TBAnimationButtonStateMinus) {
                findAnimationForTransition = YES;
                [self animationTransitionFromPLusToMinus:NO];
            }
        }break;
        default:{
            //Default state is menu
            if (state == TBAnimationButtonStateArrow) {
                findAnimationForTransition = YES;
                [self animationTransitionFromMenuToArrow:NO];
            } else if (state == TBAnimationButtonStateCross) {
                findAnimationForTransition = YES;
                [self animationTransitionFromMenuToCross:NO];
            }
        }break;
    }
    if (!findAnimationForTransition) {
        NSLog(@"Can't find animation transition for this states!");
        [self transformToState:state];
    } else {
        _currentState = state;
    }
}

#pragma mark - From menu to arrow

- (void)animationTransitionFromMenuToArrow:(BOOL)reverse
{
    NSArray *times = @[@(0.0), @(0.5), @(0.5), @(1.0)];
    
    NSArray *values = [self fromMenuToArrowAnimationValues:_topLayer
                                                   reverse:reverse];
    CAKeyframeAnimation *topAnimation = [self createKeyFrameAnimation];
    topAnimation.keyTimes = times;
    topAnimation.values = values;
    
    values = [self fromMenuToArrowAnimationValues:_bottomLayer
                                          reverse:reverse];
    CAKeyframeAnimation *bottomAnimation = [self createKeyFrameAnimation];
    bottomAnimation.keyTimes = times;
    bottomAnimation.values = values;
    
    CATransform3D middleTransform = [self arrowLineTransform:_middleLayer];
    values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
               [NSValue valueWithCATransform3D:CATransform3DIdentity],
               [NSValue valueWithCATransform3D:middleTransform],
               [NSValue valueWithCATransform3D:middleTransform]];
    if (reverse) {
        values = [[[values reverseObjectEnumerator] allObjects] mutableCopy];
    }
    times = @[@(0.0),@(0.4), @(0.4), @(1.0)];
    CAKeyframeAnimation *middleAnimation = [self createKeyFrameAnimation];
    middleAnimation.keyTimes = times;
    middleAnimation.values = values;
    [_middleLayer addAnimation:middleAnimation forKey:tbAnimationKey];
    [_topLayer addAnimation:topAnimation forKey:tbAnimationKey];
    [_bottomLayer addAnimation:bottomAnimation forKey:tbAnimationKey];
}

- (NSArray *)fromMenuToArrowAnimationValues:(CALayer *)line
                                    reverse:(BOOL)reverse
{
    NSMutableArray *values = [NSMutableArray array];
    
    CGFloat lineMult = line == _topLayer ? 1.0 : -1.0;
    CGFloat yTransform = _middleLayer.position.y-line.position.y;
    CGFloat yShift = 0.0;
    if (self.lineCap == TBAnimationButtonLineCapButt) {
        yShift = sqrt(2.0)*self.lineHeight/4.0;
    }
    
    CATransform3D transform = CATransform3DIdentity;
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    CGFloat lineShift = self.lineWidth * (1.0-tbScaleForArrow)/2.0;
    transform = CATransform3DTranslate(transform, 0.0, yTransform, 0.0);
    
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    CATransform3D scaleTransform = CATransform3DScale(transform, tbScaleForArrow, 1.0, 1.0);
    scaleTransform = CATransform3DTranslate(scaleTransform, -lineShift, 0.0, 0.0);
    
    [values addObject:[NSValue valueWithCATransform3D:scaleTransform]];
    
    transform = CATransform3DTranslate(transform, -lineShift, 0.0, 0.0);
    CGFloat xTransform = self.lineWidth/2.0 - lineShift;
    
    transform = CATransform3DTranslate(transform, -xTransform, 0.0, 0.0);
    transform = CATransform3DRotate(transform, M_PI_4*lineMult, 0.0, 0.0, -1.0);
    transform = CATransform3DTranslate(transform, xTransform, 0.0, 0.0);
    
    transform = CATransform3DScale(transform, tbScaleForArrow, 1.0, 1.0);
    transform = CATransform3DTranslate(transform, 0.0, yShift*lineMult, 0.0);
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    if (reverse) {
        values = [[[values reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return values;
}

#pragma mark - From menu to cross

- (void)animationTransitionFromMenuToCross:(BOOL)reverse
{
    NSArray *times = @[@(0.0), @(0.5), @(1.0)];
    
    NSArray *values = [self fromMenuToCrossAnimationValues:_topLayer
                                                   reverse:reverse];
    CAKeyframeAnimation *topAnimation = [self createKeyFrameAnimation];
    topAnimation.keyTimes = times;
    topAnimation.values = values;
    
    values = [self fromMenuToCrossAnimationValues:_bottomLayer
                                          reverse:reverse];
    CAKeyframeAnimation *bottomAnimation = [self createKeyFrameAnimation];
    bottomAnimation.keyTimes = times;
    bottomAnimation.values = values;
    
    CATransform3D middleTransform = CATransform3DMakeScale(0., 0., 0.);
    values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
               [NSValue valueWithCATransform3D:CATransform3DIdentity],
               [NSValue valueWithCATransform3D:middleTransform],
               [NSValue valueWithCATransform3D:middleTransform]];
    if (reverse) {
        values = [[[values reverseObjectEnumerator] allObjects] mutableCopy];
    }
    times = @[@(0.0), @(0.5), @(0.5), @(1.0)];
    CAKeyframeAnimation *middleAnimation = [self createKeyFrameAnimation];
    middleAnimation.keyTimes = times;
    middleAnimation.values = values;
    [_middleLayer addAnimation:middleAnimation forKey:tbAnimationKey];
    [_topLayer addAnimation:topAnimation forKey:tbAnimationKey];
    [_bottomLayer addAnimation:bottomAnimation forKey:tbAnimationKey];
}

- (NSArray *)fromMenuToCrossAnimationValues:(CALayer *)line
                                    reverse:(BOOL)reverse
{
    NSMutableArray *values = [NSMutableArray array];
    CGFloat lineMult = line == _topLayer ? 1.0 : -1.0;
    CGFloat yTransform = _middleLayer.position.y-line.position.y;
    
    CATransform3D transform = CATransform3DIdentity;
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    transform = CATransform3DTranslate(transform, 0, yTransform, 0.0);
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    transform = CATransform3DRotate(transform, M_PI_4*lineMult, 0.0, 0.0, 1.0);
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    if (reverse) {
        values = [[[values reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return values;
}

#pragma mark - From cross to plus

- (void)animationTransitionFromCrossToPlus:(BOOL)reverse
{
    NSArray *times = @[@(0.0), @(1.0)];
    if (reverse) {
        times = @[@(1.0), @(0.0)];
    }
    CATransform3D transform = _topLayer.transform;
    NSArray *values = @[[NSValue valueWithCATransform3D:transform],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, M_PI_2 + M_PI_4, 0.0, 0.0, 1.0)]];
    CAKeyframeAnimation *topAnimation = [self createKeyFrameAnimation];
    topAnimation.keyTimes = times;
    topAnimation.values = values;
    
    transform = _bottomLayer.transform;
    values = @[[NSValue valueWithCATransform3D:transform],
               [NSValue valueWithCATransform3D:CATransform3DRotate(transform, M_PI_2 + M_PI_4, 0.0, 0.0, 1.0)]];
    CAKeyframeAnimation *bottomAnimation = [self createKeyFrameAnimation];
    bottomAnimation.keyTimes = times;
    bottomAnimation.values = values;
    
    [_topLayer addAnimation:topAnimation forKey:tbAnimationKey];
    [_bottomLayer addAnimation:bottomAnimation forKey:tbAnimationKey];
}

#pragma mark - From plus to minus

- (void)animationTransitionFromPLusToMinus:(BOOL)reverse
{
    NSArray *times = @[@(0.0), @(1.0)];
    if (reverse) {
        times = @[@(1.0), @(0.0)];
    }
    CATransform3D transform = _topLayer.transform;
    NSArray *values = @[[NSValue valueWithCATransform3D:transform],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, -M_PI, 0.0, 0.0, 1.0)]];
    CAKeyframeAnimation *topAnimation = [self createKeyFrameAnimation];
    topAnimation.keyTimes = times;
    topAnimation.values = values;
    
    transform = _bottomLayer.transform;
    values = @[[NSValue valueWithCATransform3D:transform],
               [NSValue valueWithCATransform3D:CATransform3DRotate(transform, -M_PI_2, 0.0, 0.0, 1.0)]];
    CAKeyframeAnimation *bottomAnimation = [self createKeyFrameAnimation];
    bottomAnimation.keyTimes = times;
    bottomAnimation.values = values;
    
    [_topLayer addAnimation:topAnimation forKey:tbAnimationKey];
    [_bottomLayer addAnimation:bottomAnimation forKey:tbAnimationKey];
}

#pragma mark - Helpers

- (CAShapeLayer *)createLayer
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.lineWidth, 0)];
    
    layer.path = path.CGPath;
    layer.lineWidth = self.lineHeight;
    layer.strokeColor = self.lineColor.CGColor;
    layer.lineCap = [self lineCapString:self.lineCap];
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path,
                                                     nil,
                                                     layer.lineWidth,
                                                     kCGLineCapButt,
                                                     kCGLineJoinMiter,
                                                     layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    [self.layer addSublayer:layer];
    
    return layer;
}

- (CAKeyframeAnimation *)createKeyFrameAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = tbFrameRate * tbAnimationFrames;
    animation.removedOnCompletion = NO; // Keep changes
    animation.fillMode = kCAFillModeForwards; // Keep changes
    //Custom timing function for really smooth =)
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.60 :0.00 :0.40 :1.00];
    
    return animation;
}

- (NSString *)lineCapString:(TBAnimationButtonLineCap)lineCap
{
    switch (lineCap) {
        case TBAnimationButtonLineCapRound:
            return @"round";
        case TBAnimationButtonLineCapSquare:
            return @"square";
        default:
            return @"butt";
    }
}

@end
