//
//  DBGameInterface.m
//  Doubled
//
//  Created by Matthew Remmel on 7/17/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameInterface.h"
#import "DBGameGlobals.h"
#import "DBCasualGameScene.h"
#import "DBTimeAttackGameScene.h"
#import "DBTimeAttackGameData.h"

@implementation DBGameInterface

+ (void)setupInterface:(DBGameScene *)scene
{
    NSLog(@"SIZE: Scene width: %f Scene height: %f", scene.frame.size.width, scene.frame.size.height);
    
    if (Global_DeviceType == iPhone4Type)
    {
        NSLog(@"TYPE: Device is iPhone 4, iPhone 3, iPhone 2, or iPod Touch");
        [self setupGameScene_iPhone4: scene];
    }
    else if (Global_DeviceType == iPhone5Type)
    {
        NSLog(@"TYPE: Device is iPhone 5");
        [self setupGameScene_iPhone5: scene];
    }
    else if (Global_DeviceType == iPadType)
    {
        NSLog(@"TYPE: Device is iPad");
        [self setupGameScene_iPad: scene];
    }
    else
    {
        NSLog(@"TYPE: Could not find device type, using Standard interface");
        [self setupGameScene_iPhone4: scene];
        [scene setScaleMode: SKSceneScaleModeFill];
    }
}

+ (void)setupGameScene_iPhone4:(DBGameScene *)scene
{
    /* HUD */
    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, 300, 50)];
    titleLabel.text = @"DOUBLED";
    titleLabel.font = [UIFont fontWithName:StandardFont size:38];
    [titleLabel setTextColor:StandardFontColor];
    [scene.view addSubview:titleLabel];
    
    // Game Mode Box
    UIView *gameModeBox = [[UIView alloc] initWithFrame:CGRectMake(103, 60, 120, 40)];
    gameModeBox.backgroundColor = StandardHUDColor;
    gameModeBox.layer.cornerRadius = MenuButtonCornerRadius;
    scene.mGameModeBoxBackground = gameModeBox;
    [scene.view addSubview:gameModeBox];
    
    // Game Mode
    if ([scene class] == [DBCasualGameScene class])
    {
        UILabel *gameModeLabel = [[UILabel alloc] init];
        gameModeLabel.font = [UIFont fontWithName:StandardFont size:12];
        [gameModeLabel setTextColor:StandardFontColor];
        gameModeLabel.textAlignment = NSTextAlignmentCenter;
        gameModeLabel.numberOfLines = 2;
        gameModeLabel.frame = CGRectMake(0, 0, 120, 40);
        gameModeLabel.text = @"CASUAL\nMODE";
        [gameModeBox addSubview:gameModeLabel];
        scene.mGameModeLabel = gameModeLabel;
    }
    else if ([scene class] == [DBTimeAttackGameScene class])
    {
        UILabel *timeRemainingLabel = [[UILabel alloc] init];
        timeRemainingLabel.font = [UIFont fontWithName:StandardFont size:11];
        [timeRemainingLabel setTextColor:StandardFontColor];
        timeRemainingLabel.textAlignment = NSTextAlignmentCenter;
        timeRemainingLabel.frame = CGRectMake(0, 4, 120, 15);
        timeRemainingLabel.text = @"TIME REMAINING";
        [gameModeBox addSubview:timeRemainingLabel];
        
        UILabel *timeRemainingValue = [[UILabel alloc] init];
        timeRemainingValue.font = [UIFont fontWithName:StandardFont size:13];
        [timeRemainingValue setTextColor:StandardFontColor];
        timeRemainingValue.textAlignment = NSTextAlignmentCenter;
        timeRemainingValue.frame = CGRectMake(0, 20, 120, 15);
        timeRemainingValue.text = [NSString stringWithFormat:@"%.1f", ((DBTimeAttackGameData *)scene.mGameData).mTimeRemaining];
        [gameModeBox addSubview:timeRemainingValue];
        scene.mGameModeLabel = timeRemainingValue;
    }
    

    // Score Box
    UIView *scoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 15, 90, 40)];
    scoreBox.backgroundColor = StandardHUDColor;
    scoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:scoreBox];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"SCORE";
    scoreLabel.font = [UIFont fontWithName:StandardFont size:11];
    [scoreLabel setTextColor:StandardFontColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [scoreBox addSubview:scoreLabel];
    
    UILabel *score = [[UILabel alloc] init];
    score.text = [NSString stringWithFormat:@"%li", (long)scene.mGameData.mScore];
    score.font = [UIFont fontWithName:StandardFont size:13];
    [score setTextColor:StandardFontColor];
    score.textAlignment = NSTextAlignmentCenter;
    score.frame = CGRectMake(0, 20, 90, 15);
    score.adjustsFontSizeToFitWidth = true;
    [scoreBox addSubview:score];
    scene.mScoreLabel = score;
    
    
    // Best Score Box
    UIView *highScoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 60, 90, 40)];
    highScoreBox.backgroundColor = StandardHUDColor;
    highScoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:highScoreBox];
    
    UILabel *highScoreLabel = [[UILabel alloc] init];
    highScoreLabel.text = @"BEST";
    highScoreLabel.font = [UIFont fontWithName:StandardFont size:11];
    [highScoreLabel setTextColor:StandardFontColor];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    highScoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [highScoreBox addSubview:highScoreLabel];
    
    UILabel *highScore = [[UILabel alloc] init];
    highScore.text = [NSString stringWithFormat:@"%li", (long)scene.mGameData.mHighScore];
    highScore.font = [UIFont fontWithName:StandardFont size:13];
    [highScore setTextColor:StandardFontColor];
    highScore.textAlignment = NSTextAlignmentCenter;
    highScore.frame = CGRectMake(0, 20, 90, 15);
    highScore.adjustsFontSizeToFitWidth = true;
    [highScoreBox addSubview:highScore];
    scene.mHighScoreLabel = highScore;
    
    
    // Buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(247, 72, 65, 28);
    [menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:StandardFont size:13];
    [menuButton setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [menuButton setBackgroundColor:StandardButtonColor];
    menuButton.layer.cornerRadius = MenuButtonCornerRadius;
    [menuButton addTarget:scene action:@selector(buttonMenu) forControlEvents:UIControlEventTouchUpInside];
    [scene.view addSubview:menuButton];
    
    
    // Next Goal Label
    UILabel *goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 435, 320, 30)];
    goalLabel.text = [NSString stringWithFormat:@"Your next goal is the %li tile!", (long)scene.mGameData.mLargestTileRecord * 2];
    goalLabel.font = [UIFont fontWithName:StandardFont size:16];
    goalLabel.textAlignment = NSTextAlignmentCenter;
    [goalLabel setTextColor:StandardFontColor];
    [scene.view addSubview:goalLabel];
    scene.mGoalLabel = goalLabel;
    
    
    /* GAME BOARD */
    
    if ([scene.mGameLayer parent] == nil)
    {
        scene.mGameLayer.position = CGPointMake(-Global_TileWidth * Global_ColumnCount / 2.0, -Global_TileHeight * Global_RowCount / 2.0 - 25);
        [scene addChild:scene.mGameLayer];
        
        // Tile Background
        SKSpriteNode *tileBackground = [[SKSpriteNode alloc] initWithColor: StandardNodeBackgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount + 8, Global_TileHeight * Global_RowCount + 8)];
        tileBackground.position = CGPointMake(tileBackground.frame.size.width / 2 - 4, tileBackground.frame.size.height / 2 - 4);
        tileBackground.zPosition = -20;
        tileBackground.name = @"TileBackground";
        
        SKSpriteNode *tileBackgroundMask = [[SKSpriteNode alloc] initWithColor: [SKColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0] size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight * Global_RowCount)];
        tileBackgroundMask.zPosition = 1;
        tileBackgroundMask.name = @"TileBackgroundMask";
        [tileBackground addChild: tileBackgroundMask];
        
        SKSpriteNode *tileSpawnMaskTop = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight)];
        tileSpawnMaskTop.position = CGPointMake(0, tileSpawnMaskTop.frame.size.height / 2 + Global_TileHeight * 2 + 5);
        tileSpawnMaskTop.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskTop];
        
        
        SKSpriteNode *tileSpawnMaskBotton =[[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight)];
        tileSpawnMaskBotton.position = CGPointMake(0, -tileSpawnMaskBotton.frame.size.height / 2 - Global_TileHeight * 2 - 5);
        tileSpawnMaskBotton.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskBotton];
        
        SKSpriteNode *tileSpawnMaskRight = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth, Global_TileHeight * Global_RowCount)];
        tileSpawnMaskRight.position = CGPointMake(tileSpawnMaskRight.frame.size.width / 2 + Global_TileWidth * 2 + 5, 0);
        tileSpawnMaskRight.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskRight];
        
        SKSpriteNode *tileSpawnMaskLeft = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth, Global_TileHeight * Global_RowCount)];
        tileSpawnMaskLeft.position = CGPointMake(-tileSpawnMaskLeft.frame.size.width / 2 - Global_TileWidth * 2 -5, 0);
        tileSpawnMaskLeft.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskLeft];
        
        [scene.mGameLayer addChild: tileBackground];
    }
}

+ (void)setupGameScene_iPhone5:(DBGameScene *)scene
{
    /* HUD */
    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 15, 300, 50)];
    titleLabel.text = @"DOUBLED";
    titleLabel.font = [UIFont fontWithName:StandardFont size:38];
    [titleLabel setTextColor:StandardFontColor];
    [scene.view addSubview:titleLabel];
    
    
    // Game Mode Box
    UIView *gameModeBox = [[UIView alloc] initWithFrame:CGRectMake(103, 70, 120, 40)];
    gameModeBox.backgroundColor = StandardHUDColor;
    gameModeBox.layer.cornerRadius = MenuButtonCornerRadius;
    scene.mGameModeBoxBackground = gameModeBox;
    [scene.view addSubview:gameModeBox];
    
    
    
    // Game Mode
    if ([scene class] == [DBCasualGameScene class])
    {
        UILabel *gameModeLabel = [[UILabel alloc] init];
        gameModeLabel.font = [UIFont fontWithName:StandardFont size:12];
        [gameModeLabel setTextColor:StandardFontColor];
        gameModeLabel.textAlignment = NSTextAlignmentCenter;
        gameModeLabel.numberOfLines = 2;
        gameModeLabel.frame = CGRectMake(0, 0, 120, 40);
        gameModeLabel.text = @"CASUAL\nMODE";
        [gameModeBox addSubview:gameModeLabel];
        scene.mGameModeLabel = gameModeLabel;
    }
    else if ([scene class] == [DBTimeAttackGameScene class])
    {
        UILabel *timeRemainingLabel = [[UILabel alloc] init];
        timeRemainingLabel.font = [UIFont fontWithName:StandardFont size:11];
        [timeRemainingLabel setTextColor:StandardFontColor];
        timeRemainingLabel.textAlignment = NSTextAlignmentCenter;
        timeRemainingLabel.frame = CGRectMake(0, 4, 120, 15);
        timeRemainingLabel.text = @"TIME REMAINING";
        [gameModeBox addSubview:timeRemainingLabel];
        
        UILabel *timeRemainingValue = [[UILabel alloc] init];
        timeRemainingValue.font = [UIFont fontWithName:StandardFont size:13];
        [timeRemainingValue setTextColor:StandardFontColor];
        timeRemainingValue.textAlignment = NSTextAlignmentCenter;
        timeRemainingValue.frame = CGRectMake(0, 20, 120, 15);
        timeRemainingValue.text = [NSString stringWithFormat:@"%.1f", ((DBTimeAttackGameData *)scene.mGameData).mTimeRemaining];
        [gameModeBox addSubview:timeRemainingValue];
        scene.mGameModeLabel = timeRemainingValue;
    }
    
    
    
    
    // Score Box
    UIView *scoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 25, 90, 40)];
    scoreBox.backgroundColor = StandardHUDColor;
    scoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:scoreBox];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"SCORE";
    scoreLabel.font = [UIFont fontWithName:StandardFont size:11];
    [scoreLabel setTextColor:StandardFontColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [scoreBox addSubview:scoreLabel];
    
    UILabel *score = [[UILabel alloc] init];
    score.text = [NSString stringWithFormat:@"%li", (long)scene.mGameData.mScore];
    score.font = [UIFont fontWithName:StandardFont size:13];
    [score setTextColor:StandardFontColor];
    score.textAlignment = NSTextAlignmentCenter;
    score.frame = CGRectMake(0, 20, 90, 15);
    score.adjustsFontSizeToFitWidth = true;
    [scoreBox addSubview:score];
    scene.mScoreLabel = score;
    
    
    // Best Score Box
    UIView *highScoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 70, 90, 40)];
    highScoreBox.backgroundColor = StandardHUDColor;
    highScoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:highScoreBox];
    
    UILabel *highScoreLabel = [[UILabel alloc] init];
    highScoreLabel.text = @"BEST";
    highScoreLabel.font = [UIFont fontWithName:StandardFont size:11];
    [highScoreLabel setTextColor:StandardFontColor];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    highScoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [highScoreBox addSubview:highScoreLabel];
    
    UILabel *highScore = [[UILabel alloc] init];
    highScore.text = [NSString stringWithFormat:@"%li", (long)scene.mGameData.mHighScore];
    highScore.font = [UIFont fontWithName:StandardFont size:13];
    [highScore setTextColor:StandardFontColor];
    highScore.textAlignment = NSTextAlignmentCenter;
    highScore.frame = CGRectMake(0, 20, 90, 15);
    highScore.adjustsFontSizeToFitWidth = true;
    [highScoreBox addSubview:highScore];
    scene.mHighScoreLabel = highScore;
    
    
    // Buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(247, 82, 65, 28);
    [menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:StandardFont size:13];
    [menuButton setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [menuButton setBackgroundColor:StandardButtonColor];
    menuButton.layer.cornerRadius = MenuButtonCornerRadius;
    [menuButton addTarget:scene action:@selector(buttonMenu) forControlEvents:UIControlEventTouchUpInside];
    [scene.view addSubview:menuButton];
    
    
    // Next Goal Label
    UILabel *goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 450, 320, 30)];
    goalLabel.text = [NSString stringWithFormat:@"Your next goal is the %li tile!", (long)scene.mGameData.mLargestTileRecord * 2];
    goalLabel.font = [UIFont fontWithName:StandardFont size:16];
    goalLabel.textAlignment = NSTextAlignmentCenter;
    [goalLabel setTextColor:StandardFontColor];
    [scene.view addSubview:goalLabel];
    scene.mGoalLabel = goalLabel;
    
    
    /* GAME BOARD */
    
    if ([scene.mGameLayer parent] == nil)
    {
        scene.mGameLayer.position = CGPointMake(-Global_TileWidth * Global_ColumnCount / 2.0, -Global_TileHeight * Global_RowCount / 2.0 + 10);
        [scene addChild:scene.mGameLayer];
        
        // Tile Background
        SKSpriteNode *tileBackground = [[SKSpriteNode alloc] initWithColor: StandardNodeBackgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount + 8, Global_TileHeight * Global_RowCount + 8)];
        tileBackground.position = CGPointMake(tileBackground.frame.size.width / 2 - 4, tileBackground.frame.size.height / 2 - 4);
        tileBackground.zPosition = -20;
        tileBackground.name = @"TileBackground";
        
        SKSpriteNode *tileBackgroundMask = [[SKSpriteNode alloc] initWithColor: [SKColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0] size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight * Global_RowCount)];
        tileBackgroundMask.zPosition = 1;
        tileBackgroundMask.name = @"TileBackgroundMask";
        [tileBackground addChild: tileBackgroundMask];
        
        SKSpriteNode *tileSpawnMaskTop = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight)];
        tileSpawnMaskTop.position = CGPointMake(0, tileSpawnMaskTop.frame.size.height / 2 + Global_TileHeight * 2 + 5);
        tileSpawnMaskTop.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskTop];
        
        
        SKSpriteNode *tileSpawnMaskBotton =[[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight)];
        tileSpawnMaskBotton.position = CGPointMake(0, -tileSpawnMaskBotton.frame.size.height / 2 - Global_TileHeight * 2 - 5);
        tileSpawnMaskBotton.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskBotton];
        
        SKSpriteNode *tileSpawnMaskRight = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth, Global_TileHeight * Global_RowCount)];
        tileSpawnMaskRight.position = CGPointMake(tileSpawnMaskRight.frame.size.width / 2 + Global_TileWidth * 2 + 5, 0);
        tileSpawnMaskRight.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskRight];
        
        SKSpriteNode *tileSpawnMaskLeft = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth, Global_TileHeight * Global_RowCount)];
        tileSpawnMaskLeft.position = CGPointMake(-tileSpawnMaskLeft.frame.size.width / 2 - Global_TileWidth * 2 -5, 0);
        tileSpawnMaskLeft.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskLeft];
        
        [scene.mGameLayer addChild: tileBackground];
    }
}

+ (void)setupGameScene_iPad:(DBGameScene *)scene
{
    /* HUD */
    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 55, 380, 100)];
    titleLabel.text = @"DOUBLED";
    titleLabel.font = [UIFont fontWithName:StandardFont size:75];
    [titleLabel setTextColor:StandardFontColor];
    [scene.view addSubview:titleLabel];
    
    
    // Game Mode Box
    UIView *gameModeBox = [[UIView alloc] initWithFrame:CGRectMake(300, 155, 180, 50)];
    gameModeBox.backgroundColor = StandardHUDColor;
    gameModeBox.layer.cornerRadius = MenuButtonCornerRadius;
    scene.mGameModeBoxBackground = gameModeBox;
    [scene.view addSubview:gameModeBox];
    
    
    
    // Game Mode
    if ([scene class] == [DBCasualGameScene class])
    {
        UILabel *gameModeLabel = [[UILabel alloc] init];
        gameModeLabel.font = [UIFont fontWithName:StandardFont size:15];
        [gameModeLabel setTextColor:StandardFontColor];
        gameModeLabel.textAlignment = NSTextAlignmentCenter;
        gameModeLabel.numberOfLines = 2;
        gameModeLabel.frame = CGRectMake(0, 0, 180, 50);
        gameModeLabel.text = @"CASUAL\nMODE";
        [gameModeBox addSubview:gameModeLabel];
        scene.mGameModeLabel = gameModeLabel;
    }
    else if ([scene class] == [DBTimeAttackGameScene class])
    {
        UILabel *timeRemainingLabel = [[UILabel alloc] init];
        timeRemainingLabel.font = [UIFont fontWithName:StandardFont size:15];
        [timeRemainingLabel setTextColor:StandardFontColor];
        timeRemainingLabel.textAlignment = NSTextAlignmentCenter;
        timeRemainingLabel.frame = CGRectMake(0, 2, 180, 25);
        timeRemainingLabel.text = @"TIME REMAINING";
        [gameModeBox addSubview:timeRemainingLabel];
        
        UILabel *timeRemainingValue = [[UILabel alloc] init];
        timeRemainingValue.font = [UIFont fontWithName:StandardFont size:18];
        [timeRemainingValue setTextColor:StandardFontColor];
        timeRemainingValue.textAlignment = NSTextAlignmentCenter;
        timeRemainingValue.frame = CGRectMake(0, 22, 180, 25);
        timeRemainingValue.text = [NSString stringWithFormat:@"%.1f", ((DBTimeAttackGameData *)scene.mGameData).mTimeRemaining];
        [gameModeBox addSubview:timeRemainingValue];
        scene.mGameModeLabel = timeRemainingValue;
    }
    

    
    // Score Box
    UIView *scoreBox = [[UIView alloc] initWithFrame:CGRectMake(105, 95, 140, 50)];
    scoreBox.backgroundColor = StandardHUDColor;
    scoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:scoreBox];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"SCORE";
    scoreLabel.font = [UIFont fontWithName:StandardFont size:15];
    [scoreLabel setTextColor:StandardFontColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.frame = CGRectMake(0, 2, 140, 25);
    [scoreBox addSubview:scoreLabel];
    
    UILabel *score = [[UILabel alloc] init];
    score.text = [NSString stringWithFormat:@"%li", (long)scene.mGameData.mScore];
    score.font = [UIFont fontWithName:StandardFont size:18];
    [score setTextColor:StandardFontColor];
    score.textAlignment = NSTextAlignmentCenter;
    score.frame = CGRectMake(0, 22, 140, 25);
    score.adjustsFontSizeToFitWidth = true;
    [scoreBox addSubview:score];
    scene.mScoreLabel = score;
    
    
    // Best Score Box
    UIView *highScoreBox = [[UIView alloc] initWithFrame:CGRectMake(105, 155, 140, 50)];
    highScoreBox.backgroundColor = StandardHUDColor;
    highScoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:highScoreBox];
    
    UILabel *highScoreLabel = [[UILabel alloc] init];
    highScoreLabel.text = @"BEST";
    highScoreLabel.font = [UIFont fontWithName:StandardFont size:15];
    [highScoreLabel setTextColor:StandardFontColor];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    highScoreLabel.frame = CGRectMake(0, 2, 140, 25);
    [highScoreBox addSubview:highScoreLabel];
    
    UILabel *highScore = [[UILabel alloc] init];
    highScore.text = [NSString stringWithFormat:@"%li", (long)scene.mGameData.mHighScore];
    highScore.font = [UIFont fontWithName:StandardFont size:18];
    [highScore setTextColor:StandardFontColor];
    highScore.textAlignment = NSTextAlignmentCenter;
    highScore.frame = CGRectMake(0, 22, 140, 25);
    highScore.adjustsFontSizeToFitWidth = true;
    [highScoreBox addSubview:highScore];
    scene.mHighScoreLabel = highScore;
    
    
    // Buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(550, 160, 110, 45);
    [menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:StandardFont size:20];
    [menuButton setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [menuButton setBackgroundColor:StandardButtonColor];
    menuButton.layer.cornerRadius = MenuButtonCornerRadius;
    [menuButton addTarget:scene action:@selector(buttonMenu) forControlEvents:UIControlEventTouchUpInside];
    [scene.view addSubview:menuButton];
    
    
    // Next Goal Label
    UILabel *goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 825, 768, 60)];
    goalLabel.text = [NSString stringWithFormat:@"Your next goal is the %li tile!", (long)scene.mGameData.mLargestTileRecord * 2];
    goalLabel.font = [UIFont fontWithName:StandardFont size:30];
    goalLabel.textAlignment = NSTextAlignmentCenter;
    [goalLabel setTextColor:StandardFontColor];
    [scene.view addSubview:goalLabel];
    scene.mGoalLabel = goalLabel;
    
    
    /* GAME BOARD */
    
    if ([scene.mGameLayer parent] == nil)
    {
        scene.mGameLayer.position = CGPointMake(-Global_TileWidth * Global_ColumnCount / 2.0, -Global_TileHeight * Global_RowCount / 2.0 + 10);
        [scene addChild:scene.mGameLayer];
        
        // Tile Background
        SKSpriteNode *tileBackground = [[SKSpriteNode alloc] initWithColor: StandardNodeBackgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount + 8, Global_TileHeight * Global_RowCount + 8)];
        tileBackground.position = CGPointMake(tileBackground.frame.size.width / 2 - 4, tileBackground.frame.size.height / 2 - 4);
        tileBackground.zPosition = -20;
        tileBackground.name = @"TileBackground";
        
        SKSpriteNode *tileBackgroundMask = [[SKSpriteNode alloc] initWithColor: [SKColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0] size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight * Global_RowCount)];
        tileBackgroundMask.zPosition = 1;
        tileBackgroundMask.name = @"TileBackgroundMask";
        [tileBackground addChild: tileBackgroundMask];
        
        SKSpriteNode *tileSpawnMaskTop = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight)];
        tileSpawnMaskTop.position = CGPointMake(0, tileSpawnMaskTop.frame.size.height / 2 + Global_TileHeight * 2 + 5);
        tileSpawnMaskTop.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskTop];
        
        
        SKSpriteNode *tileSpawnMaskBotton =[[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth * Global_ColumnCount, Global_TileHeight)];
        tileSpawnMaskBotton.position = CGPointMake(0, -tileSpawnMaskBotton.frame.size.height / 2 - Global_TileHeight * 2 - 5);
        tileSpawnMaskBotton.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskBotton];
        
        SKSpriteNode *tileSpawnMaskRight = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth, Global_TileHeight * Global_RowCount)];
        tileSpawnMaskRight.position = CGPointMake(tileSpawnMaskRight.frame.size.width / 2 + Global_TileWidth * 2 + 5, 0);
        tileSpawnMaskRight.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskRight];
        
        SKSpriteNode *tileSpawnMaskLeft = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(Global_TileWidth, Global_TileHeight * Global_RowCount)];
        tileSpawnMaskLeft.position = CGPointMake(-tileSpawnMaskLeft.frame.size.width / 2 - Global_TileWidth * 2 -5, 0);
        tileSpawnMaskLeft.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskLeft];
        
        [scene.mGameLayer addChild: tileBackground];
    }
}


@end
