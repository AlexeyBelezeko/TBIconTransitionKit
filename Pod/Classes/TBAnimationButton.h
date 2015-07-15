//
//  TBAnimationButton.h
//  AnimatedButtonTransition
//
//  Created by Alexey on 7/2/15.
//  Copyright (c) 2015 SFÇD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TBAnimationButtonState) {
    TBAnimationButtonStateMenu,
    TBAnimationButtonStateArrow,
    TBAnimationButtonStateCross,
    TBAnimationButtonStatePlus,
    TBAnimationButtonStateMinus,
};

typedef NS_ENUM(NSInteger, TBAnimationButtonLineCap) {
    TBAnimationButtonLineCapButt,
    TBAnimationButtonLineCapRound,
    TBAnimationButtonLineCapSquare,
};

@interface TBAnimationButton : UIButton

@property (nonatomic) CGFloat lineHeight;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) UIColor *lineColor;
@property (nonatomic) TBAnimationButtonLineCap lineCap;
@property (nonatomic) TBAnimationButtonState currentState;

- (void)updateAppearance;
- (void)animationTransformToState:(TBAnimationButtonState)state;

@end
