//
//  DBGameScene.h
//  Doubled
//
//  Created by Matthew Remmel on 8/1/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DBGameData.h"
#import "DBTile.h"
#import "DBGameViewController.h"

typedef struct {
    NSInteger column;
    NSInteger row;
} TileLocation;

@interface DBGameScene : SKScene

@property DBGameViewController *mGameController;

@property DBGameData *mGameData;
@property SKNode *mGameLayer;

@property NSInteger mSwipeFromColumn;
@property NSInteger mSwipeFromRow;

@property UILabel *mScoreLabel;
@property UILabel *mHighScoreLabel;
@property UIView *mGameModeBoxBackground;
@property UILabel *mGameModeLabel;
@property UILabel *mGoalLabel;


- (void)setupNewGame;
- (void)setupContinueGame;
- (void)setupView;
- (void)addInterface;
- (void)addGameTiles;
- (void)newGameBoard;
- (NSMutableArray *)getNewGameTiles;
- (DBTile *)createGameTile;
- (BOOL)boardHasMovesLeft;

- (CGPoint)getPointForColumn:(NSInteger)column andRow:(NSInteger)row;
- (TileLocation)convertPointToLocation:(CGPoint)point;
- (DBTile *)getTileAtColumn:(NSInteger)column andRow:(NSInteger)row;
- (void)setTile:(DBTile *)tile atColumn:(NSInteger)column andRow:(NSInteger)row;
- (NSInteger)getValueOfTileAtColumn:(NSInteger)column andRow:(NSInteger)row;
- (BOOL)tryMergeHorizantal:(NSInteger)horizDelta andVertical:(NSInteger)vertDelta;
- (void)animateTile:(DBTile *)fromTile mergeWith:(DBTile *)toTile;
- (void)fillTileHolesWithHorizantal:(NSInteger)horizDelta andVertical:(NSInteger)vertDelta;
- (void)moveTilesToPositionWithAnimation:(BOOL)animate;

- (void)buttonMenu;

- (void)pauseGame;
- (void)unpauseGame;
- (void)checkForEndGame;
- (void)endGame;
- (void)updateHUD;
- (void)updateBoard;

@end
