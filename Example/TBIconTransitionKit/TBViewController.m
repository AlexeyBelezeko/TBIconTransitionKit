//
//  TBViewController.m
//  TBIconTransitionKit
//
//  Created by AlexeyBelezeko on 07/15/2015.
//  Copyright (c) 2015 AlexeyBelezeko. All rights reserved.
//

#import "TBViewController.h"
#import <TBIconTransitionKit/TBAnimationButton.h>

@interface TBViewController ()

@property (weak, nonatomic) IBOutlet TBAnimationButton *button1;
@property (weak, nonatomic) IBOutlet TBAnimationButton *button2;
@property (weak, nonatomic) IBOutlet TBAnimationButton *button3;
@property (weak, nonatomic) IBOutlet TBAnimationButton *button4;

@end

@implementation TBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.button1.currentState = TBAnimationButtonStateMenu;
    self.button2.currentState = TBAnimationButtonStateCross;
    self.button3.currentState = TBAnimationButtonStatePlus;
    self.button4.currentState = TBAnimationButtonStateMenu;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onButton:(TBAnimationButton *)sender
{
    if (sender == self.button1) {
        if (sender.currentState == TBAnimationButtonStateMenu) {
            [sender animationTransformToState:TBAnimationButtonStateArrow];
        } else if (sender.currentState == TBAnimationButtonStateArrow) {
            [sender animationTransformToState:TBAnimationButtonStateMenu];
        }
    } else if (sender == self.button2) {
        if (sender.currentState == TBAnimationButtonStateCross) {
            [sender animationTransformToState:TBAnimationButtonStatePlus];
        } else if (sender.currentState == TBAnimationButtonStatePlus) {
            [sender animationTransformToState:TBAnimationButtonStateCross];
        }
    } else if (sender == self.button3) {
        if (sender.currentState == TBAnimationButtonStatePlus) {
            [sender animationTransformToState:TBAnimationButtonStateMinus];
        } else if (sender.currentState == TBAnimationButtonStateMinus) {
            [sender animationTransformToState:TBAnimationButtonStatePlus];
        }
    } else if (sender == self.button4) {
        if (sender.currentState == TBAnimationButtonStateMenu) {
            [sender animationTransformToState:TBAnimationButtonStateCross];
        } else if (sender.currentState == TBAnimationButtonStateCross) {
            [sender animationTransformToState:TBAnimationButtonStateMenu];
        }
    }
}

@end
