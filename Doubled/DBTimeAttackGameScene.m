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

@property BOOL mContentCreated;
@property BOOL mGameIsPaused;
@property BOOL mStartGameAlertIsVisible;
@property BOOL mGameModeColorIsAnimateing;
@property NSTimeInterval mLastUpdateTimeInterval;

@end

@implementation DBTimeAttackGameScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self createContent];
        self.mGameData = [DBTimeAttackGameData sharedInstance];
    }
    
    return self;
}


#pragma mark - Setup

- (void)createContent
{
    if (!self.mContentCreated)
    {
        self.mContentCreated = true;
    }
}


#pragma mark - Overrides

- (void)setupNewGame
{
    self.mGameIsPaused = true;
    
    [super setupNewGame];
    ((DBTimeAttackGameData *)self.mGameData).mTimeRemaining = TimeAttackStartingTime;
    [self updateTimeRemainingLabel];
    [self showStartGameAlertWithPause];
}

- (void)setupContinueGame
{
    self.mGameIsPaused = true;
    
    if (((DBTimeAttackGameData *)self.mGameData).mTimeRemaining <= 0)
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
    if (!self.mGameIsPaused)
    {
        BOOL didMerge = [super tryMergeHorizantal:horizDelta andVertical:vertDelta];
        
        if (didMerge)
        {
            ((DBTimeAttackGameData *)self.mGameData).mTimeRemaining += TimeAttackMergeAddTime;
            [self updateTimeRemainingLabel];
        }
        
        return didMerge;
    }
    
    return false;
}

- (void)endGame
{
    [super endGame];
    self.mGameIsPaused = true;
    
    if (((DBTimeAttackGameData *)self.mGameData).mTimeRemaining < 0) ((DBTimeAttackGameData *)self.mGameData).mTimeRemaining = 0;
    [self updateTimeRemainingLabel];
}


#pragma mark - Update

- (void)update:(NSTimeInterval)currentTime
{
    if (!self.mGameIsPaused)
    {
        CFTimeInterval timeSinceLast = currentTime - self.mLastUpdateTimeInterval;
        double timeRemaining = ((DBTimeAttackGameData *)self.mGameData).mTimeRemaining;
        
        if (timeSinceLast > 1)
        {
            self.mLastUpdateTimeInterval = currentTime;
            return;
        }

        if (timeSinceLast > 0.1)
        {
            timeRemaining -= timeSinceLast;
            self.mLastUpdateTimeInterval = currentTime;
            ((DBTimeAttackGameData *)self.mGameData).mTimeRemaining = timeRemaining;
            [self updateTimeRemainingLabel];
        }
        
        if (timeRemaining <= 0)
        {
            [self endGame];
            self.mGameIsPaused = true;
        }
    }
}

- (void)updateTimeRemainingLabel
{
    self.mGameModeLabel.text = [NSString stringWithFormat:@"%.1f", ((DBTimeAttackGameData *)self.mGameData).mTimeRemaining];
    
    if (!self.mGameModeColorIsAnimateing)
    {
        double timeRemaining = ((DBTimeAttackGameData *)self.mGameData).mTimeRemaining;
        self.mGameModeColorIsAnimateing = true;
        if (timeRemaining < 3)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.mGameModeBoxBackground.backgroundColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.6 alpha:1.0];
            }completion:^(BOOL finished) {
                self.mGameModeColorIsAnimateing = false;
            }];
        }
        else if (timeRemaining < 7)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.mGameModeBoxBackground.backgroundColor = [UIColor colorWithRed:1.0 green:0.98 blue:0.6 alpha:1.0];
            }completion:^(BOOL finished) {
                self.mGameModeColorIsAnimateing = false;
            }];
        }
        else if (timeRemaining >= 7)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.mGameModeBoxBackground.backgroundColor = [UIColor colorWithRed:0.6 green:1.0 blue:0.7 alpha:1.0];
            }completion:^(BOOL finished) {
                self.mGameModeColorIsAnimateing = false;
            }];
        }
    }
}

- (void)pauseGame
{
    self.mGameIsPaused = true;
}

- (void)unpauseGame
{
    self.mGameIsPaused = false;
}


#pragma mark - Start Game Alert

- (void)showStartGameAlertWithPause
{
    NSTimer *startGameAlertTimer = [NSTimer scheduledTimerWithTimeInterval: 0.35 target: self selector: @selector(showStartGameAlert) userInfo: nil repeats: false];
    [startGameAlertTimer setTolerance: 0.1];
}

- (void)showStartGameAlert
{
    if (!self.mStartGameAlertIsVisible)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ready?" message:@"Clicking START will start the timer. If the timer reaches zero the game will end. Time is added everytime you make a move. Be quick." delegate:self cancelButtonTitle:@"START" otherButtonTitles:nil];
        [alert show];
        self.mStartGameAlertIsVisible = true;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.mGameIsPaused = false;
    }
    self.mStartGameAlertIsVisible = false;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"SCNE: Time attack game scene did deallocate");
}


@end
