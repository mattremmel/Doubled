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

@property (weak, nonatomic) IBOutlet UIButton *buttonBackground;
@property (weak, nonatomic) IBOutlet UIButton *buttonNewGame;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinue;

@property (weak, nonatomic) id target;
@property SEL actionNewGame;
@property SEL actionContinueGame;

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
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.85];
    
    self.buttonBackground.layer.cornerRadius = 5;
    self.buttonBackground.layer.shadowOpacity = 0.8;
    self.buttonBackground.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    self.buttonNewGame.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonContinue.layer.cornerRadius = MenuButtonCornerRadius;
}

#pragma mark - Target Methods

- (void)setActionTarget:(id)target actionNewGame:(SEL)newGameAction actionContinueGame:(SEL)continueAction
{
    self.target = target;
    self.actionNewGame = newGameAction;
    self.actionContinueGame = continueAction;
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
        [self removeAnimate];
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

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}


#pragma mark - Button Events

- (IBAction)buttonNewGame:(id)sender
{
    [self removeAnimate];
    if ([self.target respondsToSelector:self.actionNewGame])
    {
        [self.target performSelector:self.actionNewGame];
    }
}

- (IBAction)buttonContinueGame:(id)sender
{
    [self removeAnimate];
    if ([self.target respondsToSelector:self.actionContinueGame])
    {
        [self.target performSelector:self.actionContinueGame];
    }
}


#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches began");
    [self removeAnimate];
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Game option controller did deallocate");
}

@end
