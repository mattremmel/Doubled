//
//  DBGameViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 8/1/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "DBGameScene.h"
#import "DBCasualGameScene.h"
#import "DBTimeAttackGameScene.h"
#import "DBGameGlobals.h"


@interface DBGameViewController ()

@property DBCasualGameScene *mCasualGameScene;
@property DBTimeAttackGameScene *mTimeAttackGameScene;
@property SKView *mSKView;

@end

@implementation DBGameViewController


#pragma mark - Initilization

- (id)init
{
    NSLog(@"CONT: Game controller initilized");
    self = [super init];
    if (self)
    {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self configureCasualGameScene];
        [self configureTimeAttackGameScene];
    }
    
    return self;
}


#pragma mark - View Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Configuration

- (void)configureCasualGameScene
{
    self.mCasualGameScene = [[DBCasualGameScene alloc] initWithSize:self.view.frame.size];
    self.mCasualGameScene.mGameController = self;
}

- (void)configureTimeAttackGameScene
{
    self.mTimeAttackGameScene = [[DBTimeAttackGameScene alloc] initWithSize:self.view.frame.size];
    self.mTimeAttackGameScene.mGameController = self;
}


#pragma mark - Start Game

- (void)startCasualNewGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.mCasualGameScene setupNewGame];
    [self presentViewWithScene:self.mCasualGameScene];
}

- (void)startCasualContinueGame
{
    NSLog(@"CONT: Presenting continue casual game scene");
    [self.mCasualGameScene setupContinueGame];
    [self presentViewWithScene:self.mCasualGameScene];
}

- (void)startTimeAttackNewGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.mTimeAttackGameScene setupNewGame];
    [self presentViewWithScene:self.mTimeAttackGameScene];
}

- (void)startTimeAttackContinueGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.mTimeAttackGameScene setupContinueGame];
    [self presentViewWithScene:self.mTimeAttackGameScene];
}

- (void)presentViewWithScene:(DBGameScene *)scene
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.mSKView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:self.mSKView];
    [self.mSKView presentScene:scene];
    [scene addInterface];
}

- (BOOL)casualGameInProgress
{
    return (self.mCasualGameScene.mGameData.mScore > 300) ? true : false;
}

- (BOOL)timeAttackGameInProgress
{
    return (self.mTimeAttackGameScene.mGameData.mScore > 300) ? true : false;
}


#pragma mark - Controller Delegate Methods

- (void)dismissGameController
{
    [self.mSKView removeFromSuperview];
    self.mSKView = nil;
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return true;
}

- (BOOL)shouldAutorotate
{
    return false;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortraitUpsideDown;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Game controller did deallocate");
}

@end
