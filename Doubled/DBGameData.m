//
//  DBGameData.m
//  Doubled
//
//  Created by Matthew Remmel on 6/13/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameData.h"
#import "DBGameGlobals.h"
#import <GameKit/GameKit.h>

@interface DBGameData() <NSCoding>

@end

@implementation DBGameData

#pragma mark - Initialization

- (id)init
{
    if (self = [super init]) {
        NSLog(@"DATA: Initializing game data instance");
        
        [self setDefaultValues];
        
        if ([NSUbiquitousKeyValueStore defaultStore])
        {
            [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateFromiCloud) name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification object: nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(saveGameData) name:AppWillResignActive object:nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(saveGameData) name: AppWillTerminate object: nil];
    }
    
    return self;
}


#pragma mark - NSCoding Protocol Methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSLog(@"DATA: Encoding game data with coder");
    
    [encoder encodeInteger: self.score forKey: DBGameDataScoreKey];
    [encoder encodeInteger: self.highScore forKey: DBGameDataHighScoreKey];
    [encoder encodeInteger: self.cumulativeScore forKey: DBGameDataCumulScoreKey];
    [encoder encodeInteger: self.moves forKey: DBGameDataMovesKey];
    [encoder encodeInteger: self.totalMoves forKey: DBGameDataTotalMovesKey];
    [encoder encodeInteger: self.currentLargestTile forKey: DBGameDataCurrentLargestTileKey];
    [encoder encodeInteger: self.largestTileRecord forKey:DBGameDataLargestTileKey];
    [encoder encodeInteger: self.tile4Count forKey: DBGameDataTile4CountKey];
    [encoder encodeInteger: self.tile8Count forKey: DBGameDataTile8CountKey];
    [encoder encodeInteger: self.tile16Count forKey: DBGameDataTile16CountKey];
    [encoder encodeInteger: self.tile32Count forKey: DBGameDataTile32CountKey];
    [encoder encodeInteger: self.tile64Count forKey: DBGameDataTile64CountKey];
    [encoder encodeInteger: self.tile128Count forKey: DBGameDataTile128CountKey];
    [encoder encodeInteger: self.tile256Count forKey: DBGameDataTile256CountKey];
    [encoder encodeInteger: self.tile512Count forKey: DBGameDataTile512CountKey];
    [encoder encodeInteger: self.tile1024Count forKey: DBGameDataTile1024CountKey];
    [encoder encodeInteger: self.tile2048Count forKey: DBGameDataTile2048CountKey];
    [encoder encodeInteger: self.tile4096Count forKey: DBGameDataTile4096CountKey];
    [encoder encodeInteger: self.tile8192Count forKey: DBGameDataTile8192CountKey];
    [encoder encodeInteger: self.tile16384Count forKey: DBGameDataTile16384CountKey];
    [encoder encodeInteger: self.tile32768Count forKey: DBGameDataTile32768CountKey];
    [encoder encodeInteger: self.tile65536Count forKey: DBGameDataTile65536CountKey];
    [encoder encodeInteger: self.gamesPlayed forKey:DBGameDataGamesPlayedKey];
    [encoder encodeObject: self.gameboard forKey: DBGameDataGameBoardKey];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    NSLog(@"DATA: Initializing game data with coder");
    
    self = [super init];
    
    self.score = [decoder decodeIntegerForKey: DBGameDataScoreKey];
    self.highScore = [decoder decodeIntegerForKey: DBGameDataHighScoreKey];
    self.cumulativeScore = [decoder decodeIntegerForKey: DBGameDataCumulScoreKey];
    self.moves = [decoder decodeIntegerForKey: DBGameDataMovesKey];
    self.totalMoves = [decoder decodeIntegerForKey: DBGameDataTotalMovesKey];
    self.currentLargestTile = [decoder decodeIntegerForKey: DBGameDataCurrentLargestTileKey];
    self.largestTileRecord = [decoder decodeIntegerForKey: DBGameDataLargestTileKey];
    self.tile4Count = [decoder decodeIntegerForKey: DBGameDataTile4CountKey];
    self.tile8Count = [decoder decodeIntegerForKey: DBGameDataTile8CountKey];
    self.tile16Count = [decoder decodeIntegerForKey: DBGameDataTile16CountKey];
    self.tile32Count = [decoder decodeIntegerForKey: DBGameDataTile32CountKey];
    self.tile64Count = [decoder decodeIntegerForKey: DBGameDataTile64CountKey];
    self.tile128Count = [decoder decodeIntegerForKey: DBGameDataTile128CountKey];
    self.tile256Count = [decoder decodeIntegerForKey: DBGameDataTile256CountKey];
    self.tile512Count = [decoder decodeIntegerForKey: DBGameDataTile512CountKey];
    self.tile1024Count = [decoder decodeIntegerForKey: DBGameDataTile1024CountKey];
    self.tile2048Count = [decoder decodeIntegerForKey: DBGameDataTile2048CountKey];
    self.tile4096Count = [decoder decodeIntegerForKey: DBGameDataTile4096CountKey];
    self.tile8192Count = [decoder decodeIntegerForKey: DBGameDataTile8192CountKey];
    self.tile16384Count = [decoder decodeIntegerForKey: DBGameDataTile16384CountKey];
    self.tile32768Count = [decoder decodeIntegerForKey: DBGameDataTile32768CountKey];
    self.tile65536Count = [decoder decodeIntegerForKey: DBGameDataTile65536CountKey];
    self.gamesPlayed = [decoder decodeIntegerForKey: DBGameDataGamesPlayedKey];
    self.gameboard = [decoder decodeObjectForKey: DBGameDataGameBoardKey];
    
    return self;
}

#pragma mark - Setters

- (void)setDefaultValues
{
    NSLog(@"DATA: Setting default values");
    
    self.score = 0;
    self.highScore = 0;
    self.cumulativeScore = 0;
    self.moves = 0;
    self.totalMoves = 0;
    self.currentLargestTile = 4;
    self.largestTileRecord = 4;
    self.tile4Count = 0;
    self.tile8Count = 0;
    self.tile16Count = 0;
    self.tile32Count = 0;
    self.tile64Count = 0;
    self.tile128Count = 0;
    self.tile256Count = 0;
    self.tile512Count = 0;
    self.tile1024Count = 0;
    self.tile2048Count = 0;
    self.tile4096Count = 0;
    self.tile4096Count = 0;
    self.tile8192Count = 0;
    self.tile16384Count = 0;
    self.tile32768Count = 0;
    self.tile65536Count = 0;
    self.gamesPlayed = 0;
    self.gameboard = [[NSMutableArray alloc] init];
}


#pragma mark - Persistance

- (NSData *)loadGameData
{
    NSLog(@"DATA: Loading game data from path: %@", [self getFilePath]);
    
    NSData *decodedData = [NSData dataWithContentsOfFile: [self getFilePath] options:NSDataReadingMappedAlways error:nil];
    if (decodedData != nil)
    {
        DBGameData *data = (DBGameData *)[NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        
        self.score = data.score;
        self.highScore = data.highScore;
        self.cumulativeScore = data.cumulativeScore;
        self.moves = data.moves;
        self.totalMoves = data.totalMoves;
        self.currentLargestTile = data.currentLargestTile;
        self.largestTileRecord = data.largestTileRecord;
        self.tile4Count = data.tile4Count;
        self.tile8Count = data.tile8Count;
        self.tile16Count = data.tile16Count;
        self.tile32Count = data.tile32Count;
        self.tile64Count = data.tile64Count;
        self.tile128Count = data.tile128Count;
        self.tile256Count = data.tile256Count;
        self.tile512Count = data.tile512Count;
        self.tile1024Count = data.tile1024Count;
        self.tile2048Count = data.tile2048Count;
        self.tile4096Count = data.tile4096Count;
        self.tile8192Count = data.tile8192Count;
        self.tile16384Count = data.tile16384Count;
        self.tile32768Count = data.tile32768Count;
        self.tile65536Count = data.tile65536Count;
        self.gamesPlayed = data.gamesPlayed;
        self.gameboard = data.gameboard;
    }
    
    [self updateFromiCloud];
    
    return decodedData;
}

- (void)saveGameData
{
    NSLog(@"DATA: Saving game data to path: %@", [self getFilePath]);
    
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile: [self getFilePath] atomically:true];
    [self updateiCloud];
}

- (NSString *)getFilePath
{
    NSLog(@"ERROR: Must be overridden to load from correct file path");
    assert(false);
}


#pragma mark - Data Management

- (void)increaseScoreBy:(NSInteger)deltaScore
{
    self.score += deltaScore;
    self.cumulativeScore += deltaScore;
    
    if (self.score > self.highScore)
    {
        self.highScore = self.score;
    }
    
    switch (deltaScore) {
        case 4:
            self.tile4Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 8:
            self.tile8Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 16:
            self.tile16Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 32:
            self.tile32Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 64:
            self.tile64Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 128:
            self.tile128Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 256:
            self.tile256Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 512:
            self.tile512Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 1024:
            self.tile1024Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 2048:
            self.tile2048Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 4096:
            self.tile4096Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 8192:
            self.tile8192Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 16384:
            self.tile16384Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 32769:
            self.tile32768Count++;
            [self updateLargestTile: deltaScore];
            break;
        case 65536:
            self.tile65536Count++;
            [self updateLargestTile: deltaScore];
            break;
        default:
            NSLog(@"ERROR: Increased score by value not in switch statement");
            break;
    }
}

-(void)updateLargestTile:(NSInteger)tileValue
{
    if (tileValue > self.currentLargestTile)
    {
        self.currentLargestTile = tileValue;
    }
    
    if (tileValue > self.largestTileRecord)
    {
        self.largestTileRecord = tileValue;
    }
}

- (void)addMove
{
    ++self.moves;
    ++self.totalMoves;
}

- (void)increaseGamesPlayed
{
    ++self.gamesPlayed;
}

- (void)resetGameDataForNewGame
{
    self.score = 0;
    self.moves = 0;
    self.currentLargestTile = 2;
}

- (void)resetAllGameData
{
    NSLog(@"DATA: Resetting ALL game data");
    
    for (int i = 0; i < [self.gameboard count]; ++i)
    {
        DBTile *tile = [self.gameboard objectAtIndex:i];
        [tile removeFromParent];
        tile = nil;
    }
    
    [self setDefaultValues];
    [self saveGameData];
    
    if ([NSUbiquitousKeyValueStore defaultStore])
    {
        [[NSUbiquitousKeyValueStore defaultStore] setString: @"0" forKey: [self getiCloudHighScoreKey]];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
    
    // Reset game center data and acheivments
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


#pragma mark - Game Center

- (void)reportHighScoreToGameCenter
{
    if (gameCenterAuthenticated && gameCenterEnabled)
    {
        NSLog(@"DATA: Reporting score to game center");
        if (self.score > self.highScore)
        {
            GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier: [self getLeaderboardIdentifier]];
            score.value = self.score;
            
            [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
    }
}

- (NSString *)getLeaderboardIdentifier
{
    NSLog(@"Must be overridden to return correct leaderboard for game mode");
    assert(false);
}


#pragma mark - iCloud Support

- (void)updateiCloud
{
    NSLog(@"DATA: Updating to iCloud");
    
    if ([NSUbiquitousKeyValueStore defaultStore])
    {
        NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
        NSString *iCloudHighScoreString = [iCloudStore stringForKey: [self getiCloudHighScoreKey]];
        NSInteger iCloudHighScore = 0;
        if (iCloudHighScoreString != nil)
        {
            iCloudHighScore = [iCloudHighScoreString integerValue];
        }
        
        if (self.highScore > iCloudHighScore)
        {
            NSString *stringValue = [NSString stringWithFormat: @"%li", (long)self.highScore];
            [iCloudStore setString: stringValue forKey: [self getiCloudHighScoreKey]];
            [iCloudStore synchronize];
        }
    }
}

- (void)updateFromiCloud
{
    NSLog(@"DATA: Updating from iCloud");
    
    if ([NSUbiquitousKeyValueStore defaultStore])
    {
        NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
        NSString *iCloudHighScoreString = [iCloudStore stringForKey: [self getiCloudHighScoreKey]];
        NSInteger iCloudHighScore = 0;
        if (iCloudHighScoreString != nil)
        {
            iCloudHighScore = [iCloudHighScoreString integerValue];
        }
        
        if (iCloudHighScore > self.highScore)
        {
            self.highScore = iCloudHighScore;
        }
    }
}

- (NSString *)getiCloudHighScoreKey
{
    NSLog(@"Must be overridden to return correct iCloud key for correct game mode");
    assert(false);
}


#pragma mark - Dealloc Delegate Methods

- (void)dealloc
{
    NSLog(@"APP:  Deallocating instance of game data");
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end