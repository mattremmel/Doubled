//
//  DBGameOptionViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 7/31/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameOptionViewController.h"
#import <objc/message.h>
#import "DBGameGlobals.h"

@interface DBGameOptionViewController ()

@property (weak, nonatomic) IBOutlet UIView *mButtonBackground;
@property (weak, nonatomic) IBOutlet UIButton *mButtonNewGame;
@property (weak, nonatomic) IBOutlet UIButton *mButtonContinue;

@property (weak, nonatomic) id mSELTarget;
@property SEL mActionNewGame;
@property SEL mActionContinueGame;

@end

@implementation DBGameOptionViewController


- (void)viewDidLoad
{
    NSLog(@"CONT: Game option controller did load");
    [super viewDidLoad];
    [self styleview];
}

- (void)styleview
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.85];
    
    self.mButtonBackground.backgroundColor = StandardBackgroundColor;
    self.mButtonBackground.layer.cornerRadius = 5;
    self.mButtonBackground.layer.shadowOpacity = 0.8;
    self.mButtonBackground.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    self.mButtonNewGame.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonContinue.layer.cornerRadius = MenuButtonCornerRadius;
    
    [self.mButtonNewGame setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [self.mButtonContinue setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    
    self.mButtonNewGame.backgroundColor = StandardButtonColor;
    self.mButtonContinue.backgroundColor = StandardButtonColor;
}

#pragma mark - Target Methods

- (void)setActionTarget:(id)target actionNewGame:(SEL)newGameAction actionContinueGame:(SEL)continueAction
{
    self.mSELTarget = target;
    self.mActionNewGame = newGameAction;
    self.mActionContinueGame = continueAction;
}


#pragma mark - View Animations

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [view addSubview:self.view];
    if (animated)
    {
        [self showAnimate];
    }
}

- (void)removeFromView
{
        [self removeAnimateWithCompletionSelector:nil];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimateWithCompletionSelector:(SEL)selector
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            if (selector != nil && [self.mSELTarget respondsToSelector:selector])
            {
                [self.mSELTarget performSelector:selector];
            }
        }
    }];
}


#pragma mark - Button Events

- (IBAction)buttonNewGame:(id)sender
{
    [self removeAnimateWithCompletionSelector:self.mActionNewGame];
}

- (IBAction)buttonContinueGame:(id)sender
{
    [self removeAnimateWithCompletionSelector:self.mActionContinueGame];
}


#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeAnimateWithCompletionSelector:nil];
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Game option controller did deallocate");
}

@end
