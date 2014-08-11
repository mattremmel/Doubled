//
//  DBGameInterface.m
//  Doubled
//
//  Created by Matthew Remmel on 7/17/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameInterface.h"
#import "DBGameGlobals.h"
#import "MRSpriteButton.h"
#import "DBCasualGameScene.h"
#import "DBTimeAttackGameScene.h"

@implementation DBGameInterface

+ (void)setUpInterface:(DBGameScene *)scene
{
    NSLog(@"SIZE: Scene width: %f Scene height: %f", scene.frame.size.width, scene.frame.size.height);
    
    if (deviceType == iPhone4Type)
    {
        NSLog(@"TYPE: Device is iPhone 4, iPhone 3, iPhone 2, or iPod Touch");
        [self setUpGameScene_iPhone4: scene];
    }
    else if (deviceType == iPhone5Type)
    {
        NSLog(@"TYPE: Device is iPhone 5");
        [self setUpGameScene_iPhone5: scene];
    }
    else if (deviceType == iPadType)
    {
        NSLog(@"TYPE: Device is iPad");
        [self setUpGameScene_iPad: scene];
    }
    else
    {
        NSLog(@"TYPE: Could not find device type, using default interface");
        [self setUpGameScene_iPhone4: scene];
        [scene setScaleMode: SKSceneScaleModeFill];
    }
}

+ (void)setUpGameScene_iPhone4:(DBGameScene *)scene
{
    /* HUD */
    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, 300, 50)];
    titleLabel.text = @"DOUBLED";
    titleLabel.font = [UIFont fontWithName:defaultFont size:45];
    [titleLabel setTextColor:defaultFontColor];
    [scene.view addSubview:titleLabel];
    
    // Game Mode Box
    UIView *gameModeBox = [[UIView alloc] initWithFrame:CGRectMake(103, 60, 120, 40)];
    gameModeBox.backgroundColor = defaultNodeColor;
    gameModeBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:gameModeBox];
    
    UILabel *gameModeLabel = [[UILabel alloc] init];
    
    gameModeLabel.font = [UIFont fontWithName:defaultFont size:13];
    [gameModeLabel setTextColor:defaultFontColor];
    gameModeLabel.textAlignment = NSTextAlignmentCenter;
    gameModeLabel.numberOfLines = 2;
    gameModeLabel.frame = CGRectMake(0, 0, 120, 40);
    
    // Game Mode
    if ([scene class] == [DBCasualGameScene class])
    {
        gameModeLabel.text = @"CASUAL\nMODE";
    }
    
    [gameModeBox addSubview:gameModeLabel];
    scene.gameModeLabel = gameModeLabel;
    

    // Score Box
    UIView *scoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 15, 90, 40)];
    scoreBox.backgroundColor = defaultNodeColor;
    scoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:scoreBox];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"SCORE";
    scoreLabel.font = [UIFont fontWithName:defaultFont size:12];
    [scoreLabel setTextColor:defaultFontColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [scoreBox addSubview:scoreLabel];
    
    UILabel *score = [[UILabel alloc] init];
    score.text = [NSString stringWithFormat:@"%li", (long)scene.gameData.score];
    score.font = [UIFont fontWithName:defaultFont size:15];
    [score setTextColor:defaultFontColor];
    score.textAlignment = NSTextAlignmentCenter;
    score.frame = CGRectMake(0, 20, 90, 15);
    score.adjustsFontSizeToFitWidth = true;
    [scoreBox addSubview:score];
    scene.scoreLabel = score;
    
    
    // Best Score Box
    UIView *highScoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 60, 90, 40)];
    highScoreBox.backgroundColor = defaultNodeColor;
    highScoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:highScoreBox];
    
    UILabel *highScoreLabel = [[UILabel alloc] init];
    highScoreLabel.text = @"BEST";
    highScoreLabel.font = [UIFont fontWithName:defaultFont size:12];
    [highScoreLabel setTextColor:defaultFontColor];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    highScoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [highScoreBox addSubview:highScoreLabel];
    
    UILabel *highScore = [[UILabel alloc] init];
    highScore.text = [NSString stringWithFormat:@"%li", (long)scene.gameData.highScore];
    highScore.font = [UIFont fontWithName:defaultFont size:15];
    [highScore setTextColor:defaultFontColor];
    highScore.textAlignment = NSTextAlignmentCenter;
    highScore.frame = CGRectMake(0, 20, 90, 15);
    highScore.adjustsFontSizeToFitWidth = true;
    [highScoreBox addSubview:highScore];
    scene.highScoreLabel = highScore;
    
    
    // Buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(247, 72, 65, 28);
    [menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:defaultFont size:15];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuButton setBackgroundColor:tile32Color];
    menuButton.layer.cornerRadius = MenuButtonCornerRadius;
    [menuButton addTarget:scene action:@selector(buttonMenu) forControlEvents:UIControlEventTouchUpInside];
    [scene.view addSubview:menuButton];
    
    
    // Next Goal Label
    UILabel *goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 430, 320, 30)];
    goalLabel.text = [NSString stringWithFormat:@"Your next goal is the %i tile!", scene.gameData.largestTileRecord * 2];
    goalLabel.font = [UIFont fontWithName:defaultFont size:20];
    goalLabel.textAlignment = NSTextAlignmentCenter;
    [goalLabel setTextColor:defaultFontColor];
    [scene.view addSubview:goalLabel];
    scene.goalLabel = goalLabel;
    
    
    /* GAME BOARD */
    
    if ([scene.gameLayer parent] == nil)
    {
        scene.gameLayer.position = CGPointMake(-tileWidth * columnCount / 2.0, -tileHeight * rowCount / 2.0 - 25);
        [scene addChild:scene.gameLayer];
        
        // Tile Background
        SKSpriteNode *tileBackground = [[SKSpriteNode alloc] initWithColor: defaultNodeBackgroundColor size: CGSizeMake(tileWidth * columnCount + 8, tileHeight * rowCount + 8)];
        tileBackground.position = CGPointMake(tileBackground.frame.size.width / 2 - 4, tileBackground.frame.size.height / 2 - 4);
        tileBackground.zPosition = -20;
        tileBackground.name = @"TileBackground";
        
        SKSpriteNode *tileBackgroundMask = [[SKSpriteNode alloc] initWithColor: [SKColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0] size: CGSizeMake(tileWidth * columnCount, tileHeight * rowCount)];
        tileBackgroundMask.zPosition = 1;
        tileBackgroundMask.name = @"TileBackgroundMask";
        [tileBackground addChild: tileBackgroundMask];
        
        SKSpriteNode *tileSpawnMaskTop = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(tileWidth * columnCount, tileHeight)];
        tileSpawnMaskTop.position = CGPointMake(0, tileSpawnMaskTop.frame.size.height / 2 + tileHeight * 2 + 5);
        tileSpawnMaskTop.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskTop];
        
        
        SKSpriteNode *tileSpawnMaskBotton =[[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(tileWidth * columnCount, tileHeight)];
        tileSpawnMaskBotton.position = CGPointMake(0, -tileSpawnMaskBotton.frame.size.height / 2 - tileHeight * 2 - 5);
        tileSpawnMaskBotton.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskBotton];
        
        SKSpriteNode *tileSpawnMaskRight = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(tileWidth, tileHeight * rowCount)];
        tileSpawnMaskRight.position = CGPointMake(tileSpawnMaskRight.frame.size.width / 2 + tileWidth * 2 + 5, 0);
        tileSpawnMaskRight.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskRight];
        
        SKSpriteNode *tileSpawnMaskLeft = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(tileWidth, tileHeight * rowCount)];
        tileSpawnMaskLeft.position = CGPointMake(-tileSpawnMaskLeft.frame.size.width / 2 - tileWidth * 2 -5, 0);
        tileSpawnMaskLeft.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskLeft];
        
        [scene.gameLayer addChild: tileBackground];
    }
}

+ (void)setUpGameScene_iPhone5:(DBGameScene *)scene
{
    /* HUD */
    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 15, 300, 50)];
    titleLabel.text = @"DOUBLED";
    titleLabel.font = [UIFont fontWithName:defaultFont size:45];
    [titleLabel setTextColor:defaultFontColor];
    [scene.view addSubview:titleLabel];
    
    
    // Game Mode Box
    UIView *gameModeBox = [[UIView alloc] initWithFrame:CGRectMake(103, 70, 120, 40)];
    gameModeBox.backgroundColor = defaultNodeColor;
    gameModeBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:gameModeBox];
    
    UILabel *gameModeLabel = [[UILabel alloc] init];
    gameModeLabel.font = [UIFont fontWithName:defaultFont size:13];
    [gameModeLabel setTextColor:defaultFontColor];
    gameModeLabel.textAlignment = NSTextAlignmentCenter;
    gameModeLabel.numberOfLines = 2;
    gameModeLabel.frame = CGRectMake(0, 0, 120, 40);
    
    // Game Mode
    if ([scene class] == [DBCasualGameScene class])
    {
        gameModeLabel.text = @"CASUAL\nMODE";
    }
    
    [gameModeBox addSubview:gameModeLabel];
    scene.gameModeLabel = gameModeLabel;
    
    
    // Score Box
    UIView *scoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 25, 90, 40)];
    scoreBox.backgroundColor = defaultNodeColor;
    scoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:scoreBox];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"SCORE";
    scoreLabel.font = [UIFont fontWithName:defaultFont size:12];
    [scoreLabel setTextColor:defaultFontColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [scoreBox addSubview:scoreLabel];
    
    UILabel *score = [[UILabel alloc] init];
    score.text = [NSString stringWithFormat:@"%li", (long)scene.gameData.score];
    score.font = [UIFont fontWithName:defaultFont size:15];
    [score setTextColor:defaultFontColor];
    score.textAlignment = NSTextAlignmentCenter;
    score.frame = CGRectMake(0, 20, 90, 15);
    score.adjustsFontSizeToFitWidth = true;
    [scoreBox addSubview:score];
    scene.scoreLabel = score;
    
    
    // Best Score Box
    UIView *highScoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 70, 90, 40)];
    highScoreBox.backgroundColor = defaultNodeColor;
    highScoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    [scene.view addSubview:highScoreBox];
    
    UILabel *highScoreLabel = [[UILabel alloc] init];
    highScoreLabel.text = @"BEST";
    highScoreLabel.font = [UIFont fontWithName:defaultFont size:12];
    [highScoreLabel setTextColor:defaultFontColor];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    highScoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [highScoreBox addSubview:highScoreLabel];
    
    UILabel *highScore = [[UILabel alloc] init];
    highScore.text = [NSString stringWithFormat:@"%li", (long)scene.gameData.highScore];
    highScore.font = [UIFont fontWithName:defaultFont size:15];
    [highScore setTextColor:defaultFontColor];
    highScore.textAlignment = NSTextAlignmentCenter;
    highScore.frame = CGRectMake(0, 20, 90, 15);
    highScore.adjustsFontSizeToFitWidth = true;
    [highScoreBox addSubview:highScore];
    scene.highScoreLabel = highScore;
    
    
    // Buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(247, 82, 65, 28);
    [menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:defaultFont size:15];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuButton setBackgroundColor:tile32Color];
    menuButton.layer.cornerRadius = MenuButtonCornerRadius;
    [menuButton addTarget:scene action:@selector(buttonMenu) forControlEvents:UIControlEventTouchUpInside];
    [scene.view addSubview:menuButton];
    
    
    // Next Goal Label
    UILabel *goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 450, 320, 30)];
    goalLabel.text = [NSString stringWithFormat:@"Your next goal is the %li tile!", (long)scene.gameData.largestTileRecord * 2];
    goalLabel.font = [UIFont fontWithName:defaultFont size:20];
    goalLabel.textAlignment = NSTextAlignmentCenter;
    [goalLabel setTextColor:defaultFontColor];
    [scene.view addSubview:goalLabel];
    scene.goalLabel = goalLabel;
    
    
    /* GAME BOARD */
    
    if ([scene.gameLayer parent] == nil)
    {
        scene.gameLayer.position = CGPointMake(-tileWidth * columnCount / 2.0, -tileHeight * rowCount / 2.0 + 10);
        [scene addChild:scene.gameLayer];
        
        // Tile Background
        SKSpriteNode *tileBackground = [[SKSpriteNode alloc] initWithColor: defaultNodeBackgroundColor size: CGSizeMake(tileWidth * columnCount + 8, tileHeight * rowCount + 8)];
        tileBackground.position = CGPointMake(tileBackground.frame.size.width / 2 - 4, tileBackground.frame.size.height / 2 - 4);
        tileBackground.zPosition = -20;
        tileBackground.name = @"TileBackground";
        
        SKSpriteNode *tileBackgroundMask = [[SKSpriteNode alloc] initWithColor: [SKColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0] size: CGSizeMake(tileWidth * columnCount, tileHeight * rowCount)];
        tileBackgroundMask.zPosition = 1;
        tileBackgroundMask.name = @"TileBackgroundMask";
        [tileBackground addChild: tileBackgroundMask];
        
        SKSpriteNode *tileSpawnMaskTop = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(tileWidth * columnCount, tileHeight)];
        tileSpawnMaskTop.position = CGPointMake(0, tileSpawnMaskTop.frame.size.height / 2 + tileHeight * 2 + 5);
        tileSpawnMaskTop.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskTop];
        
        
        SKSpriteNode *tileSpawnMaskBotton =[[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(tileWidth * columnCount, tileHeight)];
        tileSpawnMaskBotton.position = CGPointMake(0, -tileSpawnMaskBotton.frame.size.height / 2 - tileHeight * 2 - 5);
        tileSpawnMaskBotton.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskBotton];
        
        SKSpriteNode *tileSpawnMaskRight = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(tileWidth, tileHeight * rowCount)];
        tileSpawnMaskRight.position = CGPointMake(tileSpawnMaskRight.frame.size.width / 2 + tileWidth * 2 + 5, 0);
        tileSpawnMaskRight.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskRight];
        
        SKSpriteNode *tileSpawnMaskLeft = [[SKSpriteNode alloc] initWithColor: scene.backgroundColor size: CGSizeMake(tileWidth, tileHeight * rowCount)];
        tileSpawnMaskLeft.position = CGPointMake(-tileSpawnMaskLeft.frame.size.width / 2 - tileWidth * 2 -5, 0);
        tileSpawnMaskLeft.zPosition = 25;
        [tileBackground addChild: tileSpawnMaskLeft];
        
        [scene.gameLayer addChild: tileBackground];
    }
}

+ (void)setUpGameScene_iPad:(DBGameScene *)scene
{
    
}


@end
