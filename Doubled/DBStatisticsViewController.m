//
//  DBStatisticsViewController.m
//  Doubled
//
//  Created by Matthew on 8/12/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBStatisticsViewController.h"
#import "DBCasualGameData.h"
#import "DBTimeAttackGameData.h"
#import "DBGameGlobals.h"

@interface DBStatisticsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (strong, nonatomic) IBOutlet UIView *contentView;

// Casual Mode Labels
@property (weak, nonatomic) IBOutlet UILabel *labelCasualGamesPlayed;
@property (weak, nonatomic) IBOutlet UILabel *labelCasualLargestTileRecord;
@property (weak, nonatomic) IBOutlet UILabel *labelCasualHighScore;
@property (weak, nonatomic) IBOutlet UILabel *labelCasualCumulativeScore;
@property (weak, nonatomic) IBOutlet UILabel *labelCasualTotalMoves;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual4TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual8TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual16TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual32TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual64TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual128TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual256TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual512TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual1024TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual2048TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual4096TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual8192TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual16384TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual32768TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCasual65536TileCount;

// Time Attack Labels
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttackGamesPlayed;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttackLargestTileRecord;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttackHighScore;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttackCumulativeScore;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttackTotalMoves;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack4TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack8TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack16TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack32TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack64TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack128TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack256TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack512TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack1024TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack2048TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack4096TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack8192TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack16384TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack32768TileCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAttack65536TileCount;


@end

@implementation DBStatisticsViewController


#pragma mark - View Callback

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollViewContainer addSubview:self.contentView];
    self.scrollViewContainer.contentSize = self.contentView.frame.size;
    [self styleView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
}


#pragma mark - Styilize

- (void)styleView
{
    self.view.backgroundColor = defaultBackgroundColor;
    self.scrollViewContainer.backgroundColor = defaultBackgroundColor;
    self.contentView.backgroundColor = defaultBackgroundColor;
    
    
    self.labelCasualGamesPlayed.adjustsFontSizeToFitWidth = true;
    self.labelCasualLargestTileRecord.adjustsFontSizeToFitWidth = true;
    self.labelCasualHighScore.adjustsFontSizeToFitWidth = true;
    self.labelCasualCumulativeScore.adjustsFontSizeToFitWidth = true;
    self.labelCasualTotalMoves.adjustsFontSizeToFitWidth = true;
    self.labelCasual4TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual8TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual16TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual32TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual64TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual128TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual256TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual512TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual1024TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual2048TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual4096TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual8192TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual16384TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual32768TileCount.adjustsFontSizeToFitWidth = true;
    self.labelCasual65536TileCount.adjustsFontSizeToFitWidth = true;
    
    self.labelTimeAttackGamesPlayed.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttackLargestTileRecord.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttackHighScore.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttackCumulativeScore.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttackTotalMoves.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack4TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack8TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack16TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack32TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack64TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack128TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack256TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack512TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack1024TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack2048TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack4096TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack8192TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack16384TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack32768TileCount.adjustsFontSizeToFitWidth = true;
    self.labelTimeAttack65536TileCount.adjustsFontSizeToFitWidth = true;
}


#pragma mark - Data Management

- (void)reloadData
{
    if (![self.labelCasualTotalMoves.text isEqualToString:[NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].totalMoves]])
    {
        // Casual Game Data
        self.labelCasualGamesPlayed.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].gamesPlayed];
        self.labelCasualLargestTileRecord.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].largestTileRecord];
        self.labelCasualHighScore.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].highScore];
        self.labelCasualCumulativeScore.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].cumulativeScore];
        self.labelCasualTotalMoves.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].totalMoves];
        self.labelCasual4TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile4Count];
        self.labelCasual8TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile8Count];
        self.labelCasual16TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile16Count];
        self.labelCasual32TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile32Count];
        self.labelCasual64TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile64Count];
        self.labelCasual128TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile128Count];
        self.labelCasual256TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile256Count];
        self.labelCasual512TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile512Count];
        self.labelCasual1024TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile1024Count];
        self.labelCasual2048TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile2048Count];
        self.labelCasual4096TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile4096Count];
        self.labelCasual8192TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile8192Count];
        self.labelCasual16384TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile16384Count];
        self.labelCasual32768TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile32768Count];
        self.labelCasual65536TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBCasualGameData sharedInstance].tile65536Count];
    }
    
    
    
    if (![self.labelTimeAttackTotalMoves.text isEqualToString:[NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].totalMoves]])
    {
        // Time Attack Game Data
        self.labelTimeAttackGamesPlayed.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].gamesPlayed];
        self.labelTimeAttackLargestTileRecord.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].largestTileRecord];
        self.labelTimeAttackHighScore.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].highScore];
        self.labelTimeAttackCumulativeScore.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].cumulativeScore];
        self.labelTimeAttackTotalMoves.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].totalMoves];
        self.labelTimeAttack4TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile4Count];
        self.labelTimeAttack8TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile8Count];
        self.labelTimeAttack16TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile16Count];
        self.labelTimeAttack32TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile32Count];
        self.labelTimeAttack64TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile64Count];
        self.labelTimeAttack128TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile128Count];
        self.labelTimeAttack256TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile256Count];
        self.labelTimeAttack512TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile512Count];
        self.labelTimeAttack1024TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile1024Count];
        self.labelTimeAttack2048TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile2048Count];
        self.labelTimeAttack4096TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile4096Count];
        self.labelTimeAttack8192TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile8192Count];
        self.labelTimeAttack16384TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile16384Count];
        self.labelTimeAttack32768TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile32768Count];
        self.labelTimeAttack65536TileCount.text = [NSString stringWithFormat:@"%li", (long)[DBTimeAttackGameData sharedInstance].tile65536Count];
    }
}

@end
