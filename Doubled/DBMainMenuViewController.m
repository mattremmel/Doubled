//
//  DBMainMenuViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 7/25/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBMainMenuViewController.h"
#import <Gamekit/GameKit.h>
#import "DBGameGlobals.h"
#import "DBGameViewController.h"
#import "DBGameOptionViewController.h"

@interface DBMainMenuViewController ()

@property DBGameOptionViewController *gameOptionController;
@property DBGameViewController *gameViewController;

@property (weak, nonatomic) IBOutlet UIButton *buttonCasual;
@property (weak, nonatomic) IBOutlet UIButton *buttonTimeAttack;
@property (weak, nonatomic) IBOutlet UIButton *buttonTutorial;
@property (weak, nonatomic) IBOutlet UIButton *buttonRate;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendFeedback;

@end

@implementation DBMainMenuViewController


#pragma mark - View Delegate

- (void)viewDidLoad
{
    NSLog(@"CONT: Main menu controller did load");
    [super viewDidLoad];
    self.gameOptionController = [[DBGameOptionViewController alloc] initWithNibName:@"DBGameOptionView" bundle:nil];
    self.gameViewController = [[DBGameViewController alloc] init];
    [self styleView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.gameOptionController removeFromView];
}


#pragma mark - Style View

- (void)styleView
{
    self.buttonCasual.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonTimeAttack.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonTutorial.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonRate.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonSendFeedback.layer.cornerRadius = MenuButtonCornerRadius;
}


#pragma mark - Starting Game

- (void)startCasualNewGame
{
    NSLog(@"CONT: Presenting game view controller and starting casual new game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startCasualNewGame];
}

- (void)startCasualContinueGame
{
    NSLog(@"CONT: Presenting game view controller and starting casual continue game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startCasualContinueGame];
}

- (void)startTimeAttackNewGame
{
    
}

- (void)startTimeAttackContinueGame
{
    
}


#pragma mark - Button Events

- (IBAction)buttonCasual:(id)sender
{
    [self.gameOptionController setActionTarget:self actionNewGame:@selector(startCasualNewGame) actionContinueGame:@selector(startCasualContinueGame)];
    [self.gameOptionController showInView:self.view animated:true];
}

- (IBAction)buttonTimeAttack:(id)sender
{
    [self.gameOptionController setActionTarget:self actionNewGame:@selector(startTimeAttackNewGame) actionContinueGame:@selector(startTimeAttackContinueGame)];
    [self.gameOptionController showInView:self.view animated:true];
}

- (IBAction)buttonTutorial:(id)sender
{
}

- (IBAction)buttonRate:(id)sender
{
}

- (IBAction)buttonSendFeedback:(id)sender
{
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Main Menu controller did deallocate");
}
@end
