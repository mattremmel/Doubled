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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 300, 50)];
    titleLabel.text = @"DOUBLED";
    titleLabel.font = [UIFont fontWithName:defaultFont size:40];
    [titleLabel setTextColor:defaultFontColor];
    titleLabel.layer.shadowOpacity = 0.08;
    titleLabel.layer.shadowOffset = MenuButtonShadowOffset;
    [scene.view addSubview:titleLabel];
    
    
    // Game Mode
    if ([scene class] == [DBCasualGameScene class])
    {
        // Score Box
        UIView *gameModeBox = [[UIView alloc] initWithFrame:CGRectMake(105, 50, 120, 40)];
        gameModeBox.backgroundColor = defaultNodeColor;
        gameModeBox.layer.cornerRadius = MenuButtonCornerRadius;
        gameModeBox.layer.shadowOpacity = 0.08;
        gameModeBox.layer.shadowOffset = MenuButtonShadowOffset;
        [scene.view addSubview:gameModeBox];
        
        UILabel *gameModeLabel = [[UILabel alloc] init];
        gameModeLabel.text = @"CASUAL\nMODE";
        gameModeLabel.font = [UIFont fontWithName:defaultFont size:13];
        gameModeLabel.textAlignment = NSTextAlignmentCenter;
        gameModeLabel.numberOfLines = 2;
        gameModeLabel.frame = CGRectMake(0, 0, 120, 40);
        [gameModeBox addSubview:gameModeLabel];
    }
    

//    // Score Box
    UIView *scoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 5, 90, 40)];
    scoreBox.backgroundColor = defaultNodeColor;
    scoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    scoreBox.layer.shadowOpacity = 0.08;
    scoreBox.layer.shadowOffset = MenuButtonShadowOffset;
    [scene.view addSubview:scoreBox];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"SCORE";
    scoreLabel.font = [UIFont fontWithName:defaultFont size:12];
    [scoreLabel setTextColor:defaultFontColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [scoreBox addSubview:scoreLabel];
    
    UILabel *score = [[UILabel alloc] init];
    score.text = @"99999";
    score.font = [UIFont fontWithName:defaultFont size:15];
    [score setTextColor:defaultFontColor];
    score.textAlignment = NSTextAlignmentCenter;
    score.frame = CGRectMake(0, 20, 90, 15);
    score.adjustsFontSizeToFitWidth = true;
    [scoreBox addSubview:score];
    
    
    // Best Score Box
    UIView *highScoreBox = [[UIView alloc] initWithFrame:CGRectMake(8, 50, 90, 40)];
    highScoreBox.backgroundColor = defaultNodeColor;
    highScoreBox.layer.cornerRadius = MenuButtonCornerRadius;
    highScoreBox.layer.shadowOpacity = 0.08;
    highScoreBox.layer.shadowOffset = MenuButtonShadowOffset;
    [scene.view addSubview:highScoreBox];
    
    UILabel *highScoreLabel = [[UILabel alloc] init];
    highScoreLabel.text = @"BEST";
    highScoreLabel.font = [UIFont fontWithName:defaultFont size:12];
    [highScoreLabel setTextColor:defaultFontColor];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    highScoreLabel.frame = CGRectMake(0, 4, 90, 15);
    [highScoreBox addSubview:highScoreLabel];
    
    UILabel *highScore = [[UILabel alloc] init];
    highScore.text = @"99999";
    highScore.font = [UIFont fontWithName:defaultFont size:15];
    [highScore setTextColor:defaultFontColor];
    highScore.textAlignment = NSTextAlignmentCenter;
    highScore.frame = CGRectMake(0, 20, 90, 15);
    highScore.adjustsFontSizeToFitWidth = true;
    [highScoreBox addSubview:highScore];
    
    
    // Buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(247, 62, 65, 28);
    [menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:defaultFont size:15];
    [menuButton setTitleColor:defaultFontColor forState:UIControlStateNormal];
    [menuButton setBackgroundColor:tile4Color];
    menuButton.layer.cornerRadius = MenuButtonCornerRadius;
    menuButton.layer.shadowOpacity = 0.08;
    menuButton.layer.shadowOffset = MenuButtonShadowOffset;
    [menuButton addTarget:scene action:@selector(buttonMenu) forControlEvents:UIControlEventTouchUpInside];
    [scene.view addSubview:menuButton];
    
    
    /* GAME BOARD */
    
    if ([scene.gameLayer parent] == nil)
    {
        scene.gameLayer.position = CGPointMake(-tileWidth * columnCount / 2.0, -tileHeight * rowCount / 2.0 - 15);
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
    [self setUpGameScene_iPhone4:scene];
    scene.gameLayer.position = CGPointMake(-tileWidth * columnCount / 2.0, -tileHeight * rowCount / 2.0 + 25);
    
}

+ (void)setUpGameScene_iPad:(DBGameScene *)scene
{
    
}


@end
