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

@property BOOL mGameSceneContentCreated;
@property DBGameOverViewController *mGameOverView;

@end

@implementation DBGameScene

#pragma mark - Initilization

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self createGameSceneContent];
        self.mGameOverView = [[DBGameOverViewController alloc] initWithNibName:@"DBGameOverView" bundle:nil];
    }
    
    NSLog(@"SCNE: DBGameScene initilized");
    return self;
}


#pragma mark - Setup

- (void)createGameSceneContent
{
    if (!self.mGameSceneContentCreated)
    {
        NSLog(@"SCNE: Creating game scene content");
        [self setupView];
        self.mGameSceneContentCreated = true;
    }
}

- (void)setupNewGame
{
    NSLog(@"SCNE: Setting up new game");
    
    for (DBTile *tile in self.mGameData.mGameboard)
    {
        [tile removeFromParent];
    }
    
    [self.mGameData resetGameDataForNewGame];
    [self newGameBoard];
    [self addGameTiles];
    [self updateHUD];
    [self checkForEndGame];
    [self updateBoard];
    [self.mGameData increaseGamesPlayed];
}

- (void)setupContinueGame
{
    NSLog(@"SCNE: Setting up continue game");
    if ([self.mGameData.mGameboard count] == 0)
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
        for (DBTile *tile in self.mGameData.mGameboard)
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
    self.backgroundColor = StandardBackgroundColor;
    
    self.mGameLayer = [[SKNode alloc] init];
}

- (void)addInterface
{
    NSLog(@"FUNC: Adding HUD");
    [DBGameInterface setupInterface:self];
}

- (void)addGameTiles
{
    NSLog(@"FUNC: Adding game tiles");
    for (int i = 0; i <[self.mGameData.mGameboard count]; ++i)
    {
        [self.mGameLayer addChild: [self.mGameData.mGameboard objectAtIndex:i]];
    }
    
    [self moveTilesToPositionWithAnimation: false];
}


#pragma mark - Gameboard

- (void)newGameBoard
{
    self.mGameData.mGameboard = [self getNewGameTiles];
}

- (NSMutableArray *)getNewGameTiles
{
    NSLog(@"FUNC: Generating new game tiles");
    
    NSMutableArray *newTiles = [[NSMutableArray alloc] init];
    for (int row = 0; row < Global_RowCount; ++row)
    {
        for (int column = 0; column < Global_ColumnCount; ++column)
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
    DBTile *tile;
    
    NSInteger randNum = (long)(arc4random_uniform(100));
    
    if (self.mGameData.mCurrentLargestTile >= 1024)
    {
        if (randNum >= 0 && randNum <= 45)
        {
            tile = [[DBTile alloc] initWithValue:2];
        }
        else if (randNum >= 46 && randNum <= 90)
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
    NSInteger movesLeft = 0; // Will be twice as big as moves, because it will detect the same move twice, once for each tile
    DBTile *tileWithMove1;
    DBTile *tileWithMove2;
    
    
    for (int column = 0; column < Global_ColumnCount; ++column)
    {
        for (int row = 0; row < Global_RowCount; ++row)
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
    return CGPointMake(column * Global_TileWidth + Global_TileWidth / 2.0, row * Global_TileHeight + Global_TileHeight / 2);
}

- (TileLocation)convertPointToLocation:(CGPoint)point
{
    TileLocation location;
    
    if (point.x >= 0 && point.x < 9 * Global_TileWidth && point.y >= 0 && point.y < 9 * Global_TileHeight)
    {
        location.column = (NSInteger)(point.x / Global_TileWidth);
        location.row = (NSInteger)(point.y / Global_TileHeight);
        CGPoint tileCenter = [self getPointForColumn: location.column andRow: location.row];
        
        NSInteger touchXDistanceFromCenter = abs(point.x - tileCenter.x);
        NSInteger touchYDistanceFromCenter = abs(point.y - tileCenter.y);
        
        assert(touchXDistanceFromCenter >= 0);
        assert(touchYDistanceFromCenter >= 0);
        
        if (touchXDistanceFromCenter < Global_TouchTolerance && touchYDistanceFromCenter < Global_TouchTolerance)
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
    assert(column >= 0 && column < Global_ColumnCount);
    assert(row >= 0 && row < Global_RowCount);
    return [self.mGameData.mGameboard objectAtIndex: row * Global_ColumnCount + column];
}

- (void)setTile:(DBTile *)tile atColumn:(NSInteger)column andRow:(NSInteger)row
{
    assert(column >= 0 && column < [self.mGameData.mGameboard count] / Global_RowCount);
    assert(row >= 0 && row < Global_RowCount);
    [self.mGameData.mGameboard replaceObjectAtIndex:row * Global_ColumnCount + column withObject: tile];
}

- (NSInteger)getValueOfTileAtColumn:(NSInteger)column andRow:(NSInteger)row
{
    if (column < 0 || column >= Global_ColumnCount) return 0;
    if (row < 0 || row >= Global_RowCount) return 0;
    return [[self getTileAtColumn: column andRow: row] getValue];
}

- (BOOL)tryMergeHorizantal:(NSInteger)horizDelta andVertical:(NSInteger)vertDelta
{
    if (self.mSwipeFromColumn < 0 || self.mSwipeFromColumn >= Global_ColumnCount) return false;
    if (self.mSwipeFromRow < 0 || self.mSwipeFromRow >= Global_RowCount) return false;
    
    NSInteger toColumn = self.mSwipeFromColumn + horizDelta;
    NSInteger toRow = self.mSwipeFromRow + vertDelta;
    
    if (toColumn < 0 || toColumn >= Global_ColumnCount) return false;
    if (toRow < 0 || toRow >= Global_RowCount) return false;
    
    DBTile *fromTile = [self getTileAtColumn: self.mSwipeFromColumn andRow: self.mSwipeFromRow];
    DBTile *toTile = [self getTileAtColumn: toColumn andRow: toRow];
    
    if ([fromTile getValue] == [toTile getValue])
    {
        [toTile updateTileWithValue: [fromTile getValue] + [toTile getValue]];
        [self animateTile:fromTile mergeWith:toTile];
        [self.mGameData increaseScoreBy: [toTile getValue]];
        [fromTile markAsDeleted];
        [self fillTileHolesWithHorizantal:horizDelta andVertical:vertDelta];
        [self.mGameData addMove];
        
        if (Global_ContinuousSwipeEnabled)
        {
            self.mSwipeFromColumn = toColumn;
            self.mSwipeFromRow = toRow;
        }
        else
        {
            self.mSwipeFromColumn = -1;
            self.mSwipeFromRow = -1;
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
    for (int row = 0; row < Global_RowCount; ++row)
    {
        for (int column = 0; column < Global_ColumnCount; ++column)
        {
            if ([[self getTileAtColumn: column andRow: row] isDeleted])
            {
                if (vertDelta == -1)
                {
                    // Move all existing tiles down
                    for (int lookup = row + 1; lookup < Global_RowCount; ++lookup)
                    {
                        DBTile *tileAbove = [self getTileAtColumn:column andRow:lookup];
                        [self setTile:tileAbove atColumn:column andRow:lookup - 1];
                    }
                    
                    // Generate new tile and set to place
                    DBTile *tile = [self createGameTile];
                    tile.position = CGPointMake(column * Global_TileWidth + Global_TileWidth / 2.0, Global_RowCount * Global_TileHeight + Global_TileHeight / 2.0);
                    [self setTile:tile atColumn:column andRow:Global_RowCount - 1];
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
                    tile.position = CGPointMake(column * Global_TileWidth + Global_TileWidth / 2.0, -Global_TileHeight / 2.0);
                    [self setTile:tile atColumn:column andRow:0];
                }
                else if (horizDelta == -1)
                {
                    for (int lookRight = column + 1; lookRight < Global_ColumnCount; ++lookRight)
                    {
                        DBTile *tileRight = [self getTileAtColumn:lookRight andRow:row];
                        [self setTile:tileRight atColumn:lookRight - 1 andRow:row];
                    }
                    
                    // Generate new tile and set to place
                    DBTile *tile = [self createGameTile];
                    tile.position = CGPointMake(Global_ColumnCount * Global_TileWidth + Global_TileWidth / 2.0, row * Global_TileHeight + Global_TileHeight / 2.0);
                    [self setTile:tile atColumn:Global_ColumnCount -1 andRow:row];
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
                    tile.position = CGPointMake(-Global_TileWidth / 2.0, row * Global_TileHeight + Global_TileHeight / 2.0);
                    [self setTile:tile atColumn:0 andRow:row];
                }
            }
        }
    }
    
}

- (void)moveTilesToPositionWithAnimation:(BOOL)animate
{
    for (int row = 0; row < Global_RowCount; ++row)
    {
        for (int column = 0; column < Global_ColumnCount; ++column)
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
    [self.mGameData saveGameData];
    [self.mGameData reportHighScoreToGameCenter];
    [self.mGameOverView setActionTarget:self actionNewGame:@selector(setupNewGame) actionMainMenu:@selector(buttonMenu) actionLeaderboard:nil];
    [self.mGameOverView setScore:self.mGameData.mScore andHighScore:self.mGameData.mHighScore];
    [self.mGameOverView showInView:self.view animated:true];
}

#pragma mark - Update

- (void)updateHUD
{
    self.mScoreLabel.text = [NSString stringWithFormat: @"%li", (long)self.mGameData.mScore];
    self.mHighScoreLabel.text = [NSString stringWithFormat: @"%li", (long)self.mGameData.mHighScore];
    self.mGoalLabel.text = [NSString stringWithFormat:@"Your next goal is the %li tile!", (long)self.mGameData.mLargestTileRecord * 2];
}

- (void)updateBoard
{
    for (int i = 0; i < [self.mGameData.mGameboard count]; ++i)
    {
        DBTile *tile = [self.mGameData.mGameboard objectAtIndex:i];
        if (tile.parent != self.mGameLayer)
        {
            [self.mGameLayer addChild: tile];
        }
    }
    
    [self moveTilesToPositionWithAnimation: true];
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}


#pragma mark - Pause Game

- (void)pauseGame
{
    // no op
}

- (void)unpauseGame
{
    // no op
}


#pragma mark - Button Events

- (void)buttonMenu
{
    [self.mGameData saveGameData];
    [self.mGameController dismissGameController];
}


#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode: self.mGameLayer];
    
    TileLocation location = [self convertPointToLocation: point];
    if (location.column < 0 || location.row < 0) return;
    
    self.mSwipeFromColumn = location.column;
    self.mSwipeFromRow = location.row;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.mSwipeFromColumn == -1 || self.mSwipeFromRow == -1) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode: self.mGameLayer];
    
    TileLocation location = [self convertPointToLocation: point];
    if (location.column < 0 || location.row < 0) return;
    
    NSInteger swipeFromColumn = self.mSwipeFromColumn;
    NSInteger swipeFromRow = self.mSwipeFromRow;
    
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
    self.mSwipeFromColumn = -1;
    self.mSwipeFromRow = -1;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.mSwipeFromColumn = -1;
    self.mSwipeFromRow = -1;
}

@end
