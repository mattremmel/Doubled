//
//  DBStatisticsViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 8/12/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBStatisticsViewController.h"
#import "DBCasualGameData.h"
#import "DBTimeAttackGameData.h"
#import "DBGameGlobals.h"
#import <GameKit/GameKit.h>

@interface DBStatisticsViewController () <GKGameCenterControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollViewContainer;
@property (strong, nonatomic) IBOutlet UIView *mContentView;

//Buttons
@property (weak, nonatomic) IBOutlet UIButton *mButtonCasualLeaderboard;
@property (weak, nonatomic) IBOutlet UIButton *mButtonTimeAttackLeaderboard;

// Casual Mode Labels
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasualGamesPlayed;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasualAverageScore;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasualLargestTileRecord;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasualHighScore;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasualCumulativeScore;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasualTotalMoves;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual4TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual8TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual16TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual32TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual64TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual128TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual256TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual512TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual1024TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual2048TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual4096TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual8192TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual16384TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual32768TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCasual65536TileCount;

// Time Attack Labels
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttackGamesPlayed;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttackAverageScore;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttackLargestTileRecord;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttackHighScore;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttackCumulativeScore;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttackTotalMoves;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack4TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack8TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack16TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack32TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack64TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack128TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack256TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack512TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack1024TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack2048TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack4096TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack8192TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack16384TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack32768TileCount;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTimeAttack65536TileCount;


@end

@implementation DBStatisticsViewController


#pragma mark - View Callback

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mScrollViewContainer addSubview:self.mContentView];
    self.mScrollViewContainer.contentSize = self.mContentView.frame.size;
    [self styleView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
}


#pragma mark - Styilize

- (void)styleView
{
    self.view.backgroundColor = StandardBackgroundColor;
    self.mScrollViewContainer.backgroundColor = StandardBackgroundColor;
    self.mContentView.backgroundColor = StandardBackgroundColor;
    
    self.mButtonCasualLeaderboard.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonCasualLeaderboard.backgroundColor = StandardButtonColor;
    [self.mButtonCasualLeaderboard setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    
    self.mButtonTimeAttackLeaderboard.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonTimeAttackLeaderboard.backgroundColor = StandardButtonColor;
    [self.mButtonTimeAttackLeaderboard setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    
    
    self.mLabelCasualGamesPlayed.adjustsFontSizeToFitWidth = true;
    self.mLabelCasualAverageScore.adjustsFontSizeToFitWidth = true;
    self.mLabelCasualLargestTileRecord.adjustsFontSizeToFitWidth = true;
    self.mLabelCasualHighScore.adjustsFontSizeToFitWidth = true;
    self.mLabelCasualCumulativeScore.adjustsFontSizeToFitWidth = true;
    self.mLabelCasualTotalMoves.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual4TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual8TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual16TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual32TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual64TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual128TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual256TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual512TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual1024TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual2048TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual4096TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual8192TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual16384TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual32768TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelCasual65536TileCount.adjustsFontSizeToFitWidth = true;
    
    self.mLabelTimeAttackGamesPlayed.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttackAverageScore.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttackLargestTileRecord.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttackHighScore.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttackCumulativeScore.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttackTotalMoves.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack4TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack8TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack16TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack32TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack64TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack128TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack256TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack512TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack1024TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack2048TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack4096TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack8192TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack16384TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack32768TileCount.adjustsFontSizeToFitWidth = true;
    self.mLabelTimeAttack65536TileCount.adjustsFontSizeToFitWidth = true;
}


#pragma mark - Data Management

- (void)reloadData
{
    if (![self.mLabelCasualTotalMoves.text isEqualToString:[NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTotalMoves]])
    {
        // Casual Game Data
        self.mLabelCasualGamesPlayed.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mGamesPlayed];
        
        if ([DBCasualGameData sharedInstance].mGamesPlayed > 0)
        {
            self.mLabelCasualAverageScore.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mCumulativeScore / [DBCasualGameData sharedInstance].mGamesPlayed];
        }
        else
        {
            self.mLabelCasualAverageScore.text = @"0";
        }
        
        self.mLabelCasualLargestTileRecord.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mLargestTileRecord];
        self.mLabelCasualHighScore.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mHighScore];
        self.mLabelCasualCumulativeScore.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mCumulativeScore];
        self.mLabelCasualTotalMoves.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTotalMoves];
        self.mLabelCasual4TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile4Count];
        self.mLabelCasual8TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile8Count];
        self.mLabelCasual16TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile16Count];
        self.mLabelCasual32TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile32Count];
        self.mLabelCasual64TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile64Count];
        self.mLabelCasual128TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile128Count];
        self.mLabelCasual256TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile256Count];
        self.mLabelCasual512TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile512Count];
        self.mLabelCasual1024TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile1024Count];
        self.mLabelCasual2048TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile2048Count];
        self.mLabelCasual4096TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile4096Count];
        self.mLabelCasual8192TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile8192Count];
        self.mLabelCasual16384TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile16384Count];
        self.mLabelCasual32768TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile32768Count];
        self.mLabelCasual65536TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].mTile65536Count];
    }
    
    
    
    if (![self.mLabelTimeAttackTotalMoves.text isEqualToString:[NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTotalMoves]])
    {
        // Time Attack Game Data
        self.mLabelTimeAttackGamesPlayed.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mGamesPlayed];
        
        if ([DBTimeAttackGameData sharedInstance].mGamesPlayed > 0)
        {
            self.mLabelTimeAttackAverageScore.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mCumulativeScore / [DBTimeAttackGameData sharedInstance].mGamesPlayed];
        }
        else
        {
            self.mLabelTimeAttackAverageScore.text = @"0";
        }
        
        self.mLabelTimeAttackLargestTileRecord.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mLargestTileRecord];
        self.mLabelTimeAttackHighScore.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mHighScore];
        self.mLabelTimeAttackCumulativeScore.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mCumulativeScore];
        self.mLabelTimeAttackTotalMoves.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTotalMoves];
        self.mLabelTimeAttack4TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile4Count];
        self.mLabelTimeAttack8TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile8Count];
        self.mLabelTimeAttack16TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile16Count];
        self.mLabelTimeAttack32TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile32Count];
        self.mLabelTimeAttack64TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile64Count];
        self.mLabelTimeAttack128TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile128Count];
        self.mLabelTimeAttack256TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile256Count];
        self.mLabelTimeAttack512TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile512Count];
        self.mLabelTimeAttack1024TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile1024Count];
        self.mLabelTimeAttack2048TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile2048Count];
        self.mLabelTimeAttack4096TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile4096Count];
        self.mLabelTimeAttack8192TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile8192Count];
        self.mLabelTimeAttack16384TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile16384Count];
        self.mLabelTimeAttack32768TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile32768Count];
        self.mLabelTimeAttack65536TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].mTile65536Count];
    }
}


#pragma mark - Button Events

- (IBAction)buttonCasualLeaderboard:(id)sender
{
    [self showLeaderboardAndAchievementsWithIdentifier:[[DBCasualGameData sharedInstance] getLeaderboardIdentifier]];
}

- (IBAction)buttonTimeAttackLeaderboard:(id)sender
{
    [self showLeaderboardAndAchievementsWithIdentifier:[[DBTimeAttackGameData sharedInstance] getLeaderboardIdentifier]];
}


#pragma mark - Game Center Callback

- (void)showLeaderboardAndAchievementsWithIdentifier:(NSString *)leaderboardID
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = leaderboardID;
    [self presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
