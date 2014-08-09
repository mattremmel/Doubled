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
    
}

+ (void)setUpGameScene_iPhone5:(DBGameScene *)scene
{
    /* HUD LAYER */
    
    scene.HUDLayer.zPosition = 50;
    
    // Score Box
    SKSpriteNode *scoreBox = [[SKSpriteNode alloc] initWithColor: defaultNodeColor size: CGSizeMake(100, 40)];
    scoreBox.position = CGPointMake(scoreBox.frame.size.width / 2 - 3, tileHeight * rowCount + scoreBox.frame.size.height / 2 + 20);
    
    SKSpriteNode *scoreBoxBackground = [[SKSpriteNode alloc] initWithColor: defaultNodeBackgroundColor size:CGSizeMake(scoreBox.frame.size.width + 2, scoreBox.frame.size.height + 2)];
    scoreBoxBackground.zPosition = -1;
    [scoreBox addChild: scoreBoxBackground];
    
    SKLabelNode *scoreTextLabel = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    scoreTextLabel.text = @"SCORE:";
    scoreTextLabel.fontSize = 12;
    scoreTextLabel.fontColor = defaultFontColor;
    scoreTextLabel.position = CGPointMake(0, scoreBox.frame.size.height / 2 - scoreTextLabel.frame.size.height - 3);
    scoreTextLabel.zPosition = 1;
    [scoreBox addChild: scoreTextLabel];
    
    scene.scoreLabel = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    scene.scoreLabel.text = @"myScore";
    scene.scoreLabel.fontSize = 15;
    scene.scoreLabel.fontColor = defaultFontColor;
    scene.scoreLabel.position = CGPointMake(0, -scoreBox.frame.size.height / 2 + 9);
    scene.scoreLabel.zPosition = 1;
    [scoreBox addChild: scene.scoreLabel];
    
    [scene.HUDLayer addChild: scoreBox];
    
    
    // High Score Box
    SKSpriteNode *highScoreBox = [[SKSpriteNode alloc] initWithColor: defaultNodeColor size: scoreBox.frame.size];
    highScoreBox.position = CGPointMake(scoreBox.position.x, scoreBox.position.y + highScoreBox.frame.size.height + 5);
    
    SKSpriteNode *highScoreBoxBackground = [[SKSpriteNode alloc] initWithColor:defaultNodeBackgroundColor size:CGSizeMake(highScoreBox.frame.size.width + 2, highScoreBox.frame.size.height + 2)];
    highScoreBoxBackground.zPosition = -1;
    [highScoreBox addChild: highScoreBoxBackground];
    
    SKLabelNode *highScoreTextLabel = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    highScoreTextLabel.text = @"BEST:";
    highScoreTextLabel.fontSize = 12;
    highScoreTextLabel.fontColor = defaultFontColor;
    highScoreTextLabel.position = CGPointMake(0, highScoreBox.frame.size.height / 2 - highScoreTextLabel.frame.size.height - 3);
    highScoreTextLabel.zPosition = 1;
    [highScoreBox addChild: highScoreTextLabel];
    
    scene.highScoreLabel = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    scene.highScoreLabel.text = @"myHighScore";
    scene.highScoreLabel.fontSize = 15;
    scene.highScoreLabel.fontColor = defaultFontColor;
    scene.highScoreLabel.position = CGPointMake(0, -highScoreBox.frame.size.height / 2 + 9);
    scene.highScoreLabel.zPosition = 1;
    [highScoreBox addChild: scene.highScoreLabel];
    
    [scene.HUDLayer addChild: highScoreBox];
    
    
    // TODO: BUTTONS SHOULD BE WIRED UP IN SCENE, ESPECIALLY LEADERBOARD TO LAUNCH THE CORRECT LEADERBOARD
    
    // Menu Button
    SKSpriteNode *menuButton = [[SKSpriteNode alloc] initWithColor: defaultNodeColor size: CGSizeMake(60, 25)];
    menuButton.position = CGPointMake(menuButton.frame.size.width / 2 + tileWidth * columnCount - menuButton.frame.size.width + 3, tileHeight * rowCount + menuButton.frame.size.height / 2 + 20);
    
    SKSpriteNode *menuButtonBackground = [[SKSpriteNode alloc] initWithColor: defaultNodeBackgroundColor size:CGSizeMake(menuButton.frame.size.width + 2, menuButton.frame.size.height + 2)];
    menuButtonBackground.zPosition = -1;
    [menuButton addChild: menuButtonBackground];
    
    SKLabelNode *menuLabel = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    menuLabel.text = @"MENU";
    menuLabel.fontSize = 13;
    menuLabel.fontColor = defaultFontColor;
    menuLabel.position = CGPointMake(0, -menuLabel.frame.size.height /2);
    menuLabel.zPosition = 1;
    [menuButton addChild: menuLabel];
    
    SKSpriteNode *menuButtonTouch = [[SKSpriteNode alloc] initWithColor: [SKColor clearColor] size: CGSizeMake(menuButton.frame.size.width + 3, menuButton.frame.size.height + 15)];
    //menuButtonTouch.name = MenuButtonName;
    menuButtonTouch.zPosition = 1;
    [menuButton addChild: menuButtonTouch];
    
    [scene.HUDLayer addChild: menuButton];
    
    
    // Leaderboard Button
    SKSpriteNode *leaderboardButton = [[SKSpriteNode alloc] initWithColor: defaultNodeColor size: CGSizeMake(110, 25)];
    leaderboardButton.position = CGPointMake(menuButton.position.x - menuButton.frame.size.width / 2 - leaderboardButton.frame.size.width / 2 - 7, menuButton.position.y);
    
    SKSpriteNode *leaderboardButtonBackground = [[SKSpriteNode alloc] initWithColor: defaultNodeBackgroundColor size: CGSizeMake(leaderboardButton.frame.size.width + 2, leaderboardButton.frame.size.height + 2)];
    leaderboardButtonBackground.zPosition = -1;
    [leaderboardButton addChild: leaderboardButtonBackground];
    
    SKLabelNode *leaderboardLabel = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    leaderboardLabel.text = @"LEADERBOARD";
    leaderboardLabel.fontSize = 13;
    leaderboardLabel.fontColor = defaultFontColor;
    leaderboardLabel.position = CGPointMake(0, -leaderboardLabel.frame.size.height / 2);
    leaderboardLabel.zPosition = 5;
    [leaderboardButton addChild: leaderboardLabel];
    
    SKSpriteNode *leaderboardButtonTouch = [[SKSpriteNode alloc] initWithColor: [SKColor clearColor] size: CGSizeMake(leaderboardButton.frame.size.width + 3, leaderboardButton.frame.size.height + 15)];
    //leaderboardButtonTouch.name = LeaderboardButtonName;
    leaderboardButtonTouch.zPosition = 5;
    [leaderboardButton addChild: leaderboardButtonTouch];
    
    [scene.HUDLayer addChild: leaderboardButton];
    
    
    // Title
    SKLabelNode *gameTitle = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    gameTitle.text = @"DOUBLED";
    gameTitle.fontSize = 40;
    gameTitle.fontColor = defaultFontColor;
    gameTitle.position = CGPointMake(leaderboardButton.position.x + gameTitle.frame.size.width / 2 - leaderboardButton.frame.size.width / 2, highScoreBox.position.y - gameTitle.frame.size.height / 2);
    
    [scene.HUDLayer addChild: gameTitle];
    
    
    // End Game Button
    SKSpriteNode *endGame = [[SKSpriteNode alloc] initWithColor: defaultNodeColor size: CGSizeMake(90, 25)];
    endGame.position = CGPointMake(tileWidth * columnCount - endGame.frame.size.width / 2 + 3, -endGame.frame.size.height / 2 - 20);
    
    SKSpriteNode *replayButtonBackground = [[SKSpriteNode alloc] initWithColor: defaultNodeBackgroundColor size:CGSizeMake(endGame.frame.size.width + 2, endGame.frame.size.height + 2)];
    replayButtonBackground.zPosition = -1;
    [endGame addChild: replayButtonBackground];
    
    SKLabelNode *endGameLabel = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    endGameLabel.text = @"END GAME";
    endGameLabel.fontSize = 13;
    endGameLabel.fontColor = defaultFontColor;
    endGameLabel.position = CGPointMake(0, -endGameLabel.frame.size.height / 2 + 2);
    endGameLabel.zPosition = 1;
    [endGame addChild: endGameLabel];
    
    SKSpriteNode *endGameButtonTouch = [[SKSpriteNode alloc] initWithColor: [SKColor clearColor] size: CGSizeMake(endGame.frame.size.width + 3, endGame.frame.size.height + 15)];
    endGameButtonTouch.name = @"endGameButton";
    endGameButtonTouch.zPosition = 5;
    [endGame addChild: endGameButtonTouch];
    
    [scene.HUDLayer addChild: endGame];
    
    
    /* GAME LAYER */
    
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

+ (void)setUpGameScene_iPad:(DBGameScene *)scene
{
    
}


@end
