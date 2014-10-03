//
//  DBGameData.h
//  Doubled
//
//  Created by Matthew Remmel on 6/13/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTile.h"

// Coding Keys
#define DBGameDataScoreKey @"score"
#define DBGameDataHighScoreKey @"highScore"
#define DBGameDataCumulScoreKey @"cumulScore"
#define DBGameDataMovesKey @"moves"
#define DBGameDataTotalMovesKey @"totalMoves"
#define DBGameDataCurrentLargestTileKey @"currentLargestTile"
#define DBGameDataLargestTileKey @"largestTile"
#define DBGameDataTile4CountKey @"tile4Count"
#define DBGameDataTile8CountKey @"tile8Count"
#define DBGameDataTile16CountKey @"tile16Count"
#define DBGameDataTile32CountKey @"tile32Count"
#define DBGameDataTile64CountKey @"tile64Count"
#define DBGameDataTile128CountKey @"tile128Count"
#define DBGameDataTile256CountKey @"tile256Count"
#define DBGameDataTile512CountKey @"tile512Count"
#define DBGameDataTile1024CountKey @"tile1024Count"
#define DBGameDataTile2048CountKey @"tile2048Count"
#define DBGameDataTile4096CountKey @"tile4096Count"
#define DBGameDataTile8192CountKey @"tile8192Count"
#define DBGameDataTile16384CountKey @"tile16384Count"
#define DBGameDataTile32768CountKey @"tile32768Count"
#define DBGameDataTile65536CountKey @"tile65536Count"
#define DBGameDataGamesPlayedKey @"gamesPlayed"
#define DBGameDataGameBoardKey @"gameBoard"

@interface DBGameData : NSObject

@property NSMutableArray *mGameboard;

@property NSInteger mScore;
@property NSInteger mHighScore;
@property NSInteger mCumulativeScore;
@property NSInteger mMoves;
@property NSInteger mTotalMoves;
@property NSInteger mCurrentLargestTile;
@property NSInteger mLargestTileRecord;
@property NSInteger mTile4Count;
@property NSInteger mTile8Count;
@property NSInteger mTile16Count;
@property NSInteger mTile32Count;
@property NSInteger mTile64Count;
@property NSInteger mTile128Count;
@property NSInteger mTile256Count;
@property NSInteger mTile512Count;
@property NSInteger mTile1024Count;
@property NSInteger mTile2048Count;
@property NSInteger mTile4096Count;
@property NSInteger mTile8192Count;
@property NSInteger mTile16384Count;
@property NSInteger mTile32768Count;
@property NSInteger mTile65536Count;
@property NSInteger mGamesPlayed;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;
- (void)setDefaultValues;
- (NSData *)loadGameData;
- (void)saveGameData;
- (NSString *)getFilePath;
- (void)increaseScoreBy:(NSInteger)deltaScore;
- (void)updateLargestTile:(NSInteger)tileValue;
- (void)addMove;
- (void)increaseGamesPlayed;
- (void)resetGameDataForNewGame;
- (void)resetAllGameData;
- (void)reportHighScoreToGameCenter;
- (NSString *)getLeaderboardIdentifier;
- (NSString *)getCheckSumIdentifier;
- (void)updateiCloud;
- (void)updateFromiCloud;
- (NSString *)getiCloudHighScoreKey;


@end