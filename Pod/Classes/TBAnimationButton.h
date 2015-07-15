//
// TBAnimationButton.h
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

#import <UIKit/UIKit.h>

/** 
 Icon states. Default: TBAnimationButtonStateMenu.
 */
typedef NS_ENUM(NSInteger, TBAnimationButtonState) {
    /** 
     Hamburger menu
     */
    TBAnimationButtonStateMenu,
    /** 
     Arrow
     */
    TBAnimationButtonStateArrow,
    /** 
     Cross
     */
    TBAnimationButtonStateCross,
    /** 
     PLus
     */
    TBAnimationButtonStatePlus,
    /** 
     Minus
     */
    TBAnimationButtonStateMinus,
};

/** 
 Constatns for CAShapeLayer line cap. Default: TBAnimationButtonLineCapButt
 */
typedef NS_ENUM(NSInteger, TBAnimationButtonLineCap) {
    TBAnimationButtonLineCapButt,
    TBAnimationButtonLineCapRound,
    TBAnimationButtonLineCapSquare,
};

/**
 `TBAnimationButton` is a subclass of `UIButton` with icon. All isons draw icon with code. You can modify icon appearance by changing line width, line cap etc. All icon build with hambureger menu transformation.
 
 There are 4 animated transform between states:
 * Menu and Arrow
 * Menu and Cross
 * Cross and PLus
 * Plus and Minus
 
 @warning If you call animationTransformToState for other states, they will change without animation.
 
 For change button icon, you should set currentState to one of `TBAnimationButtonState`, and call updateApperance methode.
 */

@interface TBAnimationButton : UIButton

/**
 Icon line width in hambuger menu
 @warning for update this you should call updateAppearance
 */
@property (nonatomic) CGFloat lineHeight;
/**
 Icon line width in hambuger menu
 @warning for update this you should call updateAppearance
 */
@property (nonatomic) CGFloat lineWidth;
/**
 Space between lines in hamburger menu
 @warning for update this you should call updateAppearance
 */
@property (nonatomic) CGFloat lineSpacing;
/**
 Line color
 @warning for update this you should call updateAppearance
 */
@property (nonatomic) UIColor *lineColor;
/**
 Line cap
 @warning for update this you should call updateAppearance
 */
@property (nonatomic) TBAnimationButtonLineCap lineCap;
/**
 Current state
 You can change button icon by set currentState.
 */
@property (nonatomic) TBAnimationButtonState currentState;

/** Updates icon appearance and rebuild shapes.
 */
- (void)updateAppearance;

/** Transform to state with animation.
 *
 * @param state The new state for button
 */
- (void)animationTransformToState:(TBAnimationButtonState)state;

@end
