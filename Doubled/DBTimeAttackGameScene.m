//
//  DBTimeAttackGameScene.m
//  Doubled
//
//  Created by Matthew Remmel on 8/1/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBTimeAttackGameScene.h"
#import "DBTimeAttackGameData.h"
#import "DBGameGlobals.h"

@interface DBTimeAttackGameScene()

@property BOOL contentCreated;
@property BOOL gameIsPaused;
@property BOOL startGameAlertIsVisible;
@property NSTimeInterval lastUpdateTimeInterval;

@end

@implementation DBTimeAttackGameScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self createContent];
        self.gameData = [DBTimeAttackGameData sharedInstance];
    }
    
    return self;
}


#pragma mark - Setup

- (void)createContent
{
    if (!self.contentCreated)
    {
        self.contentCreated = true;
    }
}


#pragma mark - Overrides

- (void)setupNewGame
{
    self.gameIsPaused = true;
    
    [super setupNewGame];
    ((DBTimeAttackGameData *)self.gameData).timeRemaining = timeAttackStartingTime;
    [self updateTimeRemainingLabel];
    [self showStartGameAlertWithPause];
}

- (void)setupContinueGame
{
    self.gameIsPaused = true;
    
    if (((DBTimeAttackGameData *)self.gameData).timeRemaining <= 0)
    {
        [self setupNewGame];
    }
    else
    {
        [super setupContinueGame];
        [self updateTimeRemainingLabel];
        [self showStartGameAlertWithPause];
    }
}

- (BOOL)tryMergeHorizantal:(NSInteger)horizDelta andVertical:(NSInteger)vertDelta
{
    if (!self.gameIsPaused)
    {
        BOOL didMerge = [super tryMergeHorizantal:horizDelta andVertical:vertDelta];
        
        if (didMerge)
        {
            ((DBTimeAttackGameData *)self.gameData).timeRemaining += timeAttackMergeAddTime;
            [self updateTimeRemainingLabel];
        }
        
        return didMerge;
    }
    
    return false;
}

- (void)endGame
{
    [super endGame];
    self.gameIsPaused = true;
    
    if (((DBTimeAttackGameData *)self.gameData).timeRemaining < 0) ((DBTimeAttackGameData *)self.gameData).timeRemaining = 0;
    [self updateTimeRemainingLabel];
}


#pragma mark - Update

- (void)update:(NSTimeInterval)currentTime
{
    if (!self.gameIsPaused)
    {
        CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
        
        if (timeSinceLast > 1)
        {
            self.lastUpdateTimeInterval = currentTime;
            return;
        }

        if (timeSinceLast > 0.1)
        {
            ((DBTimeAttackGameData *)self.gameData).timeRemaining -= timeSinceLast;
            [self updateTimeRemainingLabel];
            self.lastUpdateTimeInterval = currentTime;
        }
        
        if (((DBTimeAttackGameData *)self.gameData).timeRemaining <= 0)
        {
            [self endGame];
            self.gameIsPaused = true;
        }
    }
}

- (void)updateTimeRemainingLabel
{
    self.gameModeLabel.text = [NSString stringWithFormat:@"%.1f", ((DBTimeAttackGameData *)self.gameData).timeRemaining];
}


#pragma mark - Start Game Alert

- (void)showStartGameAlertWithPause
{
    NSTimer *startGameAlertTimer = [NSTimer scheduledTimerWithTimeInterval: 0.35 target: self selector: @selector(showStartGameAlert) userInfo: nil repeats: false];
    [startGameAlertTimer setTolerance: 0.1];
}

- (void)showStartGameAlert
{
    if (!self.startGameAlertIsVisible)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ready?" message:@"Clicking OK will start the timer. If the timer reaches zero the game will end. Time is added everytime you make a move. Be quick." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        self.startGameAlertIsVisible = true;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.gameIsPaused = false;
    }
    self.startGameAlertIsVisible = false;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"SCNE: Time attack game scene did deallocate");
}


@end
