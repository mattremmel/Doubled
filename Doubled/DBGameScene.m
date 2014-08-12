//
//  DBGameScene.m
//  Doubled
//
//  Created by Matthew Remmel on 8/1/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameScene.h"
#import "DBGameInterface.h"
#import "DBGameGlobals.h"
#import "DBTile.h"
#import "DBGameOverViewController.h"

@interface DBGameScene()

@property BOOL gameSceneContentCreated;
@property DBGameOverViewController *gameOverView;

@end

@implementation DBGameScene

#pragma mark - Initilization

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self createGameSceneContent];
        self.gameOverView = [[DBGameOverViewController alloc] initWithNibName:@"DBGameOverView" bundle:nil];
    }
    
    NSLog(@"SCNE: DBGameScene initilized");
    return self;
}


#pragma mark - Setup

- (void)createGameSceneContent
{
    if (!self.gameSceneContentCreated)
    {
        NSLog(@"SCNE: Creating game scene content");
        [self setupView];
        self.gameSceneContentCreated = true;
    }
}

- (void)setupNewGame
{
    NSLog(@"SCNE: Setting up new game");
    
    for (DBTile *tile in self.gameData.gameboard)
    {
        [tile removeFromParent];
    }
    
    [self.gameData resetGameDataForNewGame];
    [self newGameBoard];
    [self addGameTiles];
    [self updateHUD];
    [self checkForEndGame];
    [self updateBoard];
}

- (void)setupContinueGame
{
    NSLog(@"SCNE: Setting up continue game");
    if ([self.gameData.gameboard count] == 0)
    {
        NSLog(@"ERROR: No previous gameboard found, generating new one");
        [self setupNewGame];
    }
    else if (![self boardHasMovesLeft])
    {
        NSLog(@"ERROR: Loaded game board has no moves, starting new game");
        [self setupNewGame];
    }
    else
    {
        for (DBTile *tile in self.gameData.gameboard)
        {
            [tile removeFromParent];
            [tile removeAllActions];
            [tile updateTileWithValue:[tile getValue]];
        }
        
        [self addGameTiles];
        [self updateHUD];
        [self checkForEndGame];
    }
}

- (void)setupView
{
    NSLog(@"FUNC: Setting up game view");
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = defaultBackgroundColor;
    
    self.gameLayer = [[SKNode alloc] init];
}

- (void)addInterface
{
    NSLog(@"FUNC: Adding HUD");
    [DBGameInterface setupInterface:self];
}

- (void)addGameTiles
{
    NSLog(@"FUNC: Adding game tiles");
    for (int i = 0; i <[self.gameData.gameboard count]; ++i)
    {
        [self.gameLayer addChild: [self.gameData.gameboard objectAtIndex:i]];
    }
    
    [self moveTilesToPositionWithAnimation: false];
}


#pragma mark - Gameboard

- (void)newGameBoard
{
    self.gameData.gameboard = [self getNewGameTiles];
}

- (NSMutableArray *)getNewGameTiles
{
    NSLog(@"FUNC: Generating new game tiles");
    
    NSMutableArray *newTiles = [[NSMutableArray alloc] init];
    for (int row = 0; row < rowCount; ++row)
    {
        for (int column = 0; column < columnCount; ++column)
        {
            DBTile *tile = [self createGameTile];
            tile.position = [self getPointForColumn:column andRow:row];
            [newTiles addObject:tile];
        }
    }
    
    return newTiles;
}

- (DBTile *)createGameTile
{
    NSLog(@"FUNC: Creating game tile");
    DBTile *tile;
    
    NSInteger randNum = (long)(arc4random_uniform(100));
    
    if (self.gameData.currentLargestTile >= 1024)
    {
        if (randNum >= 0 && randNum <= 42)
        {
            tile = [[DBTile alloc] initWithValue:2];
        }
        else if (randNum >= 43 && randNum <= 85)
        {
            tile = [[DBTile alloc] initWithValue:4];
        }
        else
        {
            tile = [[DBTile alloc] initWithValue:8];
        }
    }
    else
    {
        tile = [[DBTile alloc] init];
    }
    
    return tile;
}

- (BOOL)boardHasMovesLeft
{
    NSLog(@"FUNC: Checking for end game");
    
    NSInteger movesLeft = 0; // Will be twice as big as moves, because it will detect the same move twice, once for each tile
    DBTile *tileWithMove1;
    DBTile *tileWithMove2;
    
    
    for (int column = 0; column < columnCount; ++column)
    {
        for (int row = 0; row < rowCount; ++row)
        {
            NSInteger currentValue = [self getValueOfTileAtColumn: column andRow: row];
            NSInteger leftValue = [self getValueOfTileAtColumn: column - 1 andRow: row];
            NSInteger rightValue = [self getValueOfTileAtColumn: column + 1 andRow: row];
            NSInteger upValue = [self getValueOfTileAtColumn: column andRow: row + 1];
            NSInteger downValue = [self getValueOfTileAtColumn: column andRow: row - 1];
            
            if (currentValue == leftValue)
            {
                ++movesLeft;
                tileWithMove1 = [self getTileAtColumn: column andRow: row];
                tileWithMove2 = [self getTileAtColumn: column - 1 andRow: row];
            }
            if (currentValue == rightValue)
            {
                ++movesLeft;
                tileWithMove1 = [self getTileAtColumn: column andRow: row];
                tileWithMove2 = [self getTileAtColumn: column + 1 andRow: row];
            }
            if (currentValue == upValue)
            {
                ++movesLeft;
                tileWithMove1 = [self getTileAtColumn: column andRow: row];
                tileWithMove2 = [self getTileAtColumn: column andRow: row + 1];
            }
            if (currentValue == downValue)
            {
                ++movesLeft;
                tileWithMove1 = [self getTileAtColumn: column andRow: row];
                tileWithMove2 = [self getTileAtColumn: column andRow: row - 1];
            }
        }
    }
    
    if (movesLeft / 2 == 1)
    {
        SKAction *colorize = [SKAction colorizeWithColor:[SKColor lightGrayColor] colorBlendFactor: 0.8 duration: 0.5];
        SKAction *colorNormal = [SKAction colorizeWithColor: tileWithMove1.color colorBlendFactor: 1.0 duration: 0.5];
        SKAction *blink = [SKAction repeatActionForever: [SKAction sequence: @[colorize, colorNormal]]];
        
        [tileWithMove1 runAction: blink];
        [tileWithMove2 runAction: blink];
    }
    
    if (movesLeft == 0)
    {
        return false;
    }
    else
    {
        return true;
    }
}


#pragma mark - Tile Management

- (CGPoint)getPointForColumn:(NSInteger)column andRow:(NSInteger)row
{
    return CGPointMake(column * tileWidth + tileWidth / 2.0, row * tileHeight + tileHeight / 2);
}

- (TileLocation)convertPointToLocation:(CGPoint)point
{
    TileLocation location;
    
    if (point.x >= 0 && point.x < 9 * tileWidth && point.y >= 0 && point.y < 9 * tileHeight)
    {
        location.column = (NSInteger)(point.x / tileWidth);
        location.row = (NSInteger)(point.y / tileHeight);
        CGPoint tileCenter = [self getPointForColumn: location.column andRow: location.row];
        
        NSInteger touchXDistanceFromCenter = abs(point.x - tileCenter.x);
        NSInteger touchYDistanceFromCenter = abs(point.y - tileCenter.y);
        
        assert(touchXDistanceFromCenter >= 0);
        assert(touchYDistanceFromCenter >= 0);
        
        if (touchXDistanceFromCenter < touchTolerance && touchYDistanceFromCenter < touchTolerance)
        {
            return location;
        }
        else
        {
            location.column = -1;
            location.row = -1;
            return location;
        }
    }
    else
    {
        location.column = -1;
        location.row = -1;
        return location;
    }
}

- (DBTile *)getTileAtColumn:(NSInteger)column andRow:(NSInteger)row
{
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    return [self.gameData.gameboard objectAtIndex: row * columnCount + column];
}

- (void)setTile:(DBTile *)tile atColumn:(NSInteger)column andRow:(NSInteger)row
{
    assert(column >= 0 && column < [self.gameData.gameboard count] / rowCount);
    assert(row >= 0 && row < rowCount);
    [self.gameData.gameboard replaceObjectAtIndex:row * columnCount + column withObject: tile];
}

- (NSInteger)getValueOfTileAtColumn:(NSInteger)column andRow:(NSInteger)row
{
    if (column < 0 || column >= columnCount) return 0;
    if (row < 0 || row >= rowCount) return 0;
    return [[self getTileAtColumn: column andRow: row] getValue];
}

- (BOOL)tryMergeHorizantal:(NSInteger)horizDelta andVertical:(NSInteger)vertDelta
{
    NSLog(@"FUNC:  Trying to merge tiles");
    
    if (self.swipeFromColumn < 0 || self.swipeFromColumn >= columnCount) return false;
    if (self.swipeFromRow < 0 || self.swipeFromRow >= rowCount) return false;
    
    NSInteger toColumn = self.swipeFromColumn + horizDelta;
    NSInteger toRow = self.swipeFromRow + vertDelta;
    
    if (toColumn < 0 || toColumn >= columnCount) return false;
    if (toRow < 0 || toRow >= rowCount) return false;
    
    DBTile *fromTile = [self getTileAtColumn: self.swipeFromColumn andRow: self.swipeFromRow];
    DBTile *toTile = [self getTileAtColumn: toColumn andRow: toRow];
    
    if ([fromTile getValue] == [toTile getValue])
    {
        [toTile updateTileWithValue: [fromTile getValue] + [toTile getValue]];
        [self animateTile:fromTile mergeWith:toTile];
        [self.gameData increaseScoreBy: [toTile getValue]];
        [fromTile markAsDeleted];
        [self fillTileHolesWithHorizantal:horizDelta andVertical:vertDelta];
        [self.gameData addMove];
        
        if (continuousSwipeEnabled)
        {
            self.swipeFromColumn = toColumn;
            self.swipeFromRow = toRow;
        }
        else
        {
            self.swipeFromColumn = -1;
            self.swipeFromRow = -1;
        }
        
        return true;
    }
    else
    {
        return false;
    }
}

- (void)animateTile:(DBTile *)fromTile mergeWith:(DBTile *)toTile
{
    NSLog(@"FUNC: Animating tile merge");
    
    [fromTile removeAllActions];
    [toTile removeAllActions];
    
    SKAction *moveTileAction = [SKAction moveTo: toTile.position duration: 0.05];
    SKAction *increaseSize = [SKAction resizeByWidth: 8 height: 8 duration: 0.1];
    SKAction *decreaseSize = [SKAction resizeByWidth: -8 height: -8 duration: 0.1];
    
    fromTile.zPosition -= 2;
    [fromTile runAction: [SKAction sequence: @[moveTileAction, [SKAction removeFromParent]]]];
    
    [toTile runAction: [SKAction sequence:@[increaseSize, decreaseSize]]];
}

- (void)fillTileHolesWithHorizantal:(NSInteger)horizDelta andVertical:(NSInteger)vertDelta
{
    NSLog(@"FUNC: Filling tile holes");
    
    for (int row = 0; row < rowCount; ++row)
    {
        for (int column = 0; column < columnCount; ++column)
        {
            if ([[self getTileAtColumn: column andRow: row] isDeleted])
            {
                if (vertDelta == -1)
                {
                    // Move all existing tiles down
                    for (int lookup = row + 1; lookup < rowCount; ++lookup)
                    {
                        DBTile *tileAbove = [self getTileAtColumn:column andRow:lookup];
                        [self setTile:tileAbove atColumn:column andRow:lookup - 1];
                    }
                    
                    // Generate new tile and set to place
                    DBTile *tile = [self createGameTile];
                    tile.position = CGPointMake(column * tileWidth + tileWidth / 2.0, rowCount * tileHeight + tileHeight / 2.0);
                    [self setTile:tile atColumn:column andRow:rowCount - 1];
                }
                else if (vertDelta == 1)
                {
                    for (int lookdown = row - 1; lookdown >= 0; --lookdown)
                    {
                        DBTile *tileBelow = [self getTileAtColumn:column andRow:lookdown];
                        [self setTile:tileBelow atColumn:column andRow:lookdown + 1];
                    }
                    
                    // Generate new tile and set to place
                    DBTile *tile = [self createGameTile];
                    tile.position = CGPointMake(column * tileWidth + tileWidth / 2.0, -tileHeight / 2.0);
                    [self setTile:tile atColumn:column andRow:0];
                }
                else if (horizDelta == -1)
                {
                    for (int lookRight = column + 1; lookRight < columnCount; ++lookRight)
                    {
                        DBTile *tileRight = [self getTileAtColumn:lookRight andRow:row];
                        [self setTile:tileRight atColumn:lookRight - 1 andRow:row];
                    }
                    
                    // Generate new tile and set to place
                    DBTile *tile = [self createGameTile];
                    tile.position = CGPointMake(columnCount * tileWidth + tileWidth / 2.0, row * tileHeight + tileHeight / 2.0);
                    [self setTile:tile atColumn:columnCount -1 andRow:row];
                }
                else
                {
                    for (int lookLeft = column - 1; lookLeft >= 0; --lookLeft)
                    {
                        DBTile *tileLeft = [self getTileAtColumn:lookLeft andRow:row];
                        [self setTile:tileLeft atColumn:lookLeft + 1 andRow:row];
                    }
                    
                    // Generate new tile and set to place
                    DBTile *tile = [self createGameTile];
                    tile.position = CGPointMake(-tileWidth / 2.0, row * tileHeight + tileHeight / 2.0);
                    [self setTile:tile atColumn:0 andRow:row];
                }
            }
        }
    }
    
}

- (void)moveTilesToPositionWithAnimation:(BOOL)animate
{
    NSLog(@"FUNC: Animating moving tiles");
    
    for (int row = 0; row < rowCount; ++row)
    {
        for (int column = 0; column < columnCount; ++column)
        {
            DBTile *tile = [self getTileAtColumn:column andRow:row];
            CGPoint correctTilePosition = [self getPointForColumn:column andRow:row];
            
            if (tile.position.x != correctTilePosition.x || tile.position.y != correctTilePosition.y)
            {
                if (animate)
                {
                    SKAction *moveAction = [SKAction moveTo: correctTilePosition duration: 0.15];
                    moveAction.timingMode = SKActionTimingEaseInEaseOut;
                    [tile runAction: moveAction];
                }
                else
                {
                    tile.position = correctTilePosition;
                }
            }
        }
    }
}

- (void)checkForEndGame
{
    if (![self boardHasMovesLeft])
    {
        NSTimer *endGameTimer = [NSTimer scheduledTimerWithTimeInterval: 0.8 target: self selector: @selector(endGame) userInfo: nil repeats: false];
        [endGameTimer setTolerance: 0.1];
    }
}

- (void)endGame
{
    NSLog(@"SCNE: End game");
    [self.gameData saveGameData];
    [self.gameData reportHighScoreToGameCenter];
    [self.gameOverView setActionTarget:self actionNewGame:@selector(setupNewGame) actionMainMenu:@selector(buttonMenu) actionLeaderboard:nil];
    [self.gameOverView setScore:self.gameData.score andHighScore:self.gameData.highScore];
    [self.gameOverView showInView:self.view animated:true];
}

#pragma mark - Update

- (void)updateHUD
{
    self.scoreLabel.text = [NSString stringWithFormat: @"%li", (long)self.gameData.score];
    self.highScoreLabel.text = [NSString stringWithFormat: @"%li", (long)self.gameData.highScore];
    self.goalLabel.text = [NSString stringWithFormat:@"Your next goal is the %li tile!", (long)self.gameData.largestTileRecord * 2];
}

- (void)updateBoard
{
    for (int i = 0; i < [self.gameData.gameboard count]; ++i)
    {
        DBTile *tile = [self.gameData.gameboard objectAtIndex:i];
        if (tile.parent != self.gameLayer)
        {
            [self.gameLayer addChild: tile];
        }
    }
    
    [self moveTilesToPositionWithAnimation: true];
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}


#pragma mark - Button Events

- (void)buttonMenu
{
    NSLog(@"SCNE: Button event menu");
    [self.gameData saveGameData];
    [self.gameController dismissGameController];
}

- (void)buttonLeaderboard
{
    // TODO: Implement showing leaderboard
}


#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"DEBUG: Touches began");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode: self.gameLayer];
    
    TileLocation location = [self convertPointToLocation: point];
    if (location.column < 0 || location.row < 0) return;
    
    self.swipeFromColumn = location.column;
    self.swipeFromRow = location.row;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.swipeFromColumn == -1 || self.swipeFromRow == -1) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode: self.gameLayer];
    
    TileLocation location = [self convertPointToLocation: point];
    if (location.column < 0 || location.row < 0) return;
    
    NSInteger swipeFromColumn = self.swipeFromColumn;
    NSInteger swipeFromRow = self.swipeFromRow;
    
    NSInteger horizDelta = 0;
    NSInteger vertDelta = 0;
    
    if (location.column < swipeFromColumn)
    {
        horizDelta = -1;
    }
    else if (location.column > swipeFromColumn)
    {
        horizDelta = 1;
    }
    else if (location.row < swipeFromRow)
    {
        vertDelta = -1;
    }
    else if (location.row > swipeFromRow)
    {
        vertDelta = 1;
    }
    
    if (horizDelta != 0 || vertDelta != 0)
    {
        // Make sure the tile to try and merge is the same tile the user is touching
        if (location.column != swipeFromColumn + horizDelta || location.row != swipeFromRow + vertDelta) return;
        
        BOOL merged = [self tryMergeHorizantal: horizDelta andVertical: vertDelta];
        
        if (merged)
        {
            [self updateHUD];
            [self updateBoard];
            [self checkForEndGame];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.swipeFromColumn = -1;
    self.swipeFromRow = -1;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.swipeFromColumn = -1;
    self.swipeFromRow = -1;
}

@end
