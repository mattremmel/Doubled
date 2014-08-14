//
//  MRChildTutorialViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 7/21/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBChildTutorialViewController.h"
#import "DBGameGlobals.h"

@interface DBChildTutorialViewController ()
@property id target;
@property SEL actionDismissTutorial;
@property (weak, nonatomic) IBOutlet UIButton *buttonFinishTutorial;

@end

@implementation DBChildTutorialViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self styleView];
    
}

#pragma mark - Stylize

- (void)styleView
{
    if (self.buttonFinishTutorial)
    {
        self.buttonFinishTutorial.layer.cornerRadius = MenuButtonCornerRadius;
        self.buttonFinishTutorial.backgroundColor = defaultButtonColor;
        [self.buttonFinishTutorial setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
    }
    
    self.view.backgroundColor = defaultBackgroundColor;
}


#pragma mark - Target Action

- (void)setActionTarget:(id)target actionDismissTutorial:(SEL)dismissTutorialAction
{
    self.target = target;
    self.actionDismissTutorial = dismissTutorialAction;
}


#pragma mark - Button Events

- (IBAction)buttonFinishTutorial:(id)sender
{
    if ([self.target respondsToSelector:self.actionDismissTutorial])
    {
        [self.target performSelector:self.actionDismissTutorial];
    }
}


@end
