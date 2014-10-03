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
#import "KeychainWrapper.h"

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
    
    [encoder encodeInteger: self.mScore forKey: DBGameDataScoreKey];
    [encoder encodeInteger: self.mHighScore forKey: DBGameDataHighScoreKey];
    [encoder encodeInteger: self.mCumulativeScore forKey: DBGameDataCumulScoreKey];
    [encoder encodeInteger: self.mMoves forKey: DBGameDataMovesKey];
    [encoder encodeInteger: self.mTotalMoves forKey: DBGameDataTotalMovesKey];
    [encoder encodeInteger: self.mCurrentLargestTile forKey: DBGameDataCurrentLargestTileKey];
    [encoder encodeInteger: self.mLargestTileRecord forKey:DBGameDataLargestTileKey];
    [encoder encodeInteger: self.mTile4Count forKey: DBGameDataTile4CountKey];
    [encoder encodeInteger: self.mTile8Count forKey: DBGameDataTile8CountKey];
    [encoder encodeInteger: self.mTile16Count forKey: DBGameDataTile16CountKey];
    [encoder encodeInteger: self.mTile32Count forKey: DBGameDataTile32CountKey];
    [encoder encodeInteger: self.mTile64Count forKey: DBGameDataTile64CountKey];
    [encoder encodeInteger: self.mTile128Count forKey: DBGameDataTile128CountKey];
    [encoder encodeInteger: self.mTile256Count forKey: DBGameDataTile256CountKey];
    [encoder encodeInteger: self.mTile512Count forKey: DBGameDataTile512CountKey];
    [encoder encodeInteger: self.mTile1024Count forKey: DBGameDataTile1024CountKey];
    [encoder encodeInteger: self.mTile2048Count forKey: DBGameDataTile2048CountKey];
    [encoder encodeInteger: self.mTile4096Count forKey: DBGameDataTile4096CountKey];
    [encoder encodeInteger: self.mTile8192Count forKey: DBGameDataTile8192CountKey];
    [encoder encodeInteger: self.mTile16384Count forKey: DBGameDataTile16384CountKey];
    [encoder encodeInteger: self.mTile32768Count forKey: DBGameDataTile32768CountKey];
    [encoder encodeInteger: self.mTile65536Count forKey: DBGameDataTile65536CountKey];
    [encoder encodeInteger: self.mGamesPlayed forKey:DBGameDataGamesPlayedKey];
    [encoder encodeObject: self.mGameboard forKey: DBGameDataGameBoardKey];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    NSLog(@"DATA: Initializing game data with coder");
    
    self = [super init];
    
    self.mScore = [decoder decodeIntegerForKey: DBGameDataScoreKey];
    self.mHighScore = [decoder decodeIntegerForKey: DBGameDataHighScoreKey];
    self.mCumulativeScore = [decoder decodeIntegerForKey: DBGameDataCumulScoreKey];
    self.mMoves = [decoder decodeIntegerForKey: DBGameDataMovesKey];
    self.mTotalMoves = [decoder decodeIntegerForKey: DBGameDataTotalMovesKey];
    self.mCurrentLargestTile = [decoder decodeIntegerForKey: DBGameDataCurrentLargestTileKey];
    self.mLargestTileRecord = [decoder decodeIntegerForKey: DBGameDataLargestTileKey];
    self.mTile4Count = [decoder decodeIntegerForKey: DBGameDataTile4CountKey];
    self.mTile8Count = [decoder decodeIntegerForKey: DBGameDataTile8CountKey];
    self.mTile16Count = [decoder decodeIntegerForKey: DBGameDataTile16CountKey];
    self.mTile32Count = [decoder decodeIntegerForKey: DBGameDataTile32CountKey];
    self.mTile64Count = [decoder decodeIntegerForKey: DBGameDataTile64CountKey];
    self.mTile128Count = [decoder decodeIntegerForKey: DBGameDataTile128CountKey];
    self.mTile256Count = [decoder decodeIntegerForKey: DBGameDataTile256CountKey];
    self.mTile512Count = [decoder decodeIntegerForKey: DBGameDataTile512CountKey];
    self.mTile1024Count = [decoder decodeIntegerForKey: DBGameDataTile1024CountKey];
    self.mTile2048Count = [decoder decodeIntegerForKey: DBGameDataTile2048CountKey];
    self.mTile4096Count = [decoder decodeIntegerForKey: DBGameDataTile4096CountKey];
    self.mTile8192Count = [decoder decodeIntegerForKey: DBGameDataTile8192CountKey];
    self.mTile16384Count = [decoder decodeIntegerForKey: DBGameDataTile16384CountKey];
    self.mTile32768Count = [decoder decodeIntegerForKey: DBGameDataTile32768CountKey];
    self.mTile65536Count = [decoder decodeIntegerForKey: DBGameDataTile65536CountKey];
    self.mGamesPlayed = [decoder decodeIntegerForKey: DBGameDataGamesPlayedKey];
    self.mGameboard = [decoder decodeObjectForKey: DBGameDataGameBoardKey];
    
    return self;
}

#pragma mark - Setters

- (void)setDefaultValues
{
    NSLog(@"DATA: Setting default values");
    
    self.mScore = 0;
    self.mHighScore = 0;
    self.mCumulativeScore = 0;
    self.mMoves = 0;
    self.mTotalMoves = 0;
    self.mCurrentLargestTile = 4;
    self.mLargestTileRecord = 4;
    self.mTile4Count = 0;
    self.mTile8Count = 0;
    self.mTile16Count = 0;
    self.mTile32Count = 0;
    self.mTile64Count = 0;
    self.mTile128Count = 0;
    self.mTile256Count = 0;
    self.mTile512Count = 0;
    self.mTile1024Count = 0;
    self.mTile2048Count = 0;
    self.mTile4096Count = 0;
    self.mTile4096Count = 0;
    self.mTile8192Count = 0;
    self.mTile16384Count = 0;
    self.mTile32768Count = 0;
    self.mTile65536Count = 0;
    self.mGamesPlayed = 0;
    self.mGameboard = [[NSMutableArray alloc] init];
}


#pragma mark - Persistance

- (NSData *)loadGameData
{
    NSLog(@"DATA: Loading game data from path: %@", [self getFilePath]);
    
    NSData *decodedData = [NSData dataWithContentsOfFile: [self getFilePath] options:NSDataReadingMappedAlways error:nil];
    if (decodedData != nil)
    {
        // Check that the file hasn't been tampered with
        NSString *checksumOfSavedFile = [KeychainWrapper computeSHA256DigestForData: decodedData];
        NSString *checksumInKeychain = [KeychainWrapper keychainStringFromMatchingIdentifier: [self getCheckSumIdentifier]];
        NSLog(@"DATA: Checksum of saved file: %@", checksumOfSavedFile);
        NSLog(@"DATA: Checksum in keychain:   %@", checksumInKeychain);
        
        if (![checksumOfSavedFile isEqualToString: checksumInKeychain])
        {
            NSLog(@"DATA: File does not mach checksum, resetting data");
            [self resetAllGameData];
            return nil;
        }
        else
        {
            NSLog(@"DATA: File matches checksum, loading data");
        }
        
        DBGameData *data = (DBGameData *)[NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        
        self.mScore = data.mScore;
        self.mHighScore = data.mHighScore;
        self.mCumulativeScore = data.mCumulativeScore;
        self.mMoves = data.mMoves;
        self.mTotalMoves = data.mTotalMoves;
        self.mCurrentLargestTile = data.mCurrentLargestTile;
        self.mLargestTileRecord = data.mLargestTileRecord;
        self.mTile4Count = data.mTile4Count;
        self.mTile8Count = data.mTile8Count;
        self.mTile16Count = data.mTile16Count;
        self.mTile32Count = data.mTile32Count;
        self.mTile64Count = data.mTile64Count;
        self.mTile128Count = data.mTile128Count;
        self.mTile256Count = data.mTile256Count;
        self.mTile512Count = data.mTile512Count;
        self.mTile1024Count = data.mTile1024Count;
        self.mTile2048Count = data.mTile2048Count;
        self.mTile4096Count = data.mTile4096Count;
        self.mTile8192Count = data.mTile8192Count;
        self.mTile16384Count = data.mTile16384Count;
        self.mTile32768Count = data.mTile32768Count;
        self.mTile65536Count = data.mTile65536Count;
        self.mGamesPlayed = data.mGamesPlayed;
        self.mGameboard = data.mGameboard;
    }
    
    [self updateFromiCloud];
    
    return decodedData;
}

- (void)saveGameData
{
    NSLog(@"DATA: Saving game data to path: %@", [self getFilePath]);
    
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile: [self getFilePath] atomically:true];
    NSString* checksum = [KeychainWrapper computeSHA256DigestForData: encodedData];
    if ([KeychainWrapper keychainStringFromMatchingIdentifier: [self getCheckSumIdentifier]]) {
        [KeychainWrapper updateKeychainValue:checksum forIdentifier:[self getCheckSumIdentifier]];
    } else {
        [KeychainWrapper createKeychainValue:checksum forIdentifier:[self getCheckSumIdentifier]];
    }
    
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
    self.mScore += deltaScore;
    self.mCumulativeScore += deltaScore;
    
    if (self.mScore > self.mHighScore)
    {
        self.mHighScore = self.mScore;
    }
    
    [self updateLargestTile:deltaScore];
    
    switch (deltaScore) {
        case 4:
            self.mTile4Count++;
            break;
        case 8:
            self.mTile8Count++;
            break;
        case 16:
            self.mTile16Count++;
            break;
        case 32:
            self.mTile32Count++;
            break;
        case 64:
            self.mTile64Count++;
            break;
        case 128:
            self.mTile128Count++;
            break;
        case 256:
            self.mTile256Count++;
            break;
        case 512:
            self.mTile512Count++;
            break;
        case 1024:
            self.mTile1024Count++;
            break;
        case 2048:
            self.mTile2048Count++;
            break;
        case 4096:
            self.mTile4096Count++;
            break;
        case 8192:
            self.mTile8192Count++;
            break;
        case 16384:
            self.mTile16384Count++;
            break;
        case 32769:
            self.mTile32768Count++;
            break;
        case 65536:
            self.mTile65536Count++;
            break;
        default:
            NSLog(@"ERROR: Increased score by value not in switch statement");
            break;
    }
}

-(void)updateLargestTile:(NSInteger)tileValue
{
    if (tileValue > self.mCurrentLargestTile)
    {
        self.mCurrentLargestTile = tileValue;
    }
    
    if (tileValue > self.mLargestTileRecord)
    {
        self.mLargestTileRecord = tileValue;
    }
}

- (void)addMove
{
    ++self.mMoves;
    ++self.mTotalMoves;
}

- (void)increaseGamesPlayed
{
    ++self.mGamesPlayed;
}

- (void)resetGameDataForNewGame
{
    self.mScore = 0;
    self.mMoves = 0;
    self.mCurrentLargestTile = 4;
}

- (void)resetAllGameData
{
    NSLog(@"DATA: Resetting ALL game data");
    
    for (int i = 0; i < [self.mGameboard count]; ++i)
    {
        DBTile *tile = [self.mGameboard objectAtIndex:i];
        [tile removeFromParent];
        tile = nil;
    }
    
    [self setDefaultValues];
    [self saveGameData];
    
    if (Global_iCloudEnabled)
    {
        if ([NSUbiquitousKeyValueStore defaultStore])
        {
            [[NSUbiquitousKeyValueStore defaultStore] setString: @"0" forKey: [self getiCloudHighScoreKey]];
            [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        }
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
    if (gameCenterAuthenticated && Global_GameCenterEnabled)
    {
        NSLog(@"DATA: Reporting score to game center");
        GKScore *highscore = [[GKScore alloc] initWithLeaderboardIdentifier: [self getLeaderboardIdentifier]];
        highscore.value = self.mHighScore;
        
        [GKScore reportScores:@[highscore] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

- (NSString *)getLeaderboardIdentifier
{
    NSLog(@"Must be overridden to return correct leaderboard for game mode");
    assert(false);
}


#pragma mark - Security

- (NSString *)getCheckSumIdentifier
{
    NSLog(@"Must be overridden to return correct checksum identifier for game mode");
    assert(false);
}


#pragma mark - iCloud Support

- (void)updateiCloud
{
    if (Global_iCloudEnabled)
    {
        if ([NSUbiquitousKeyValueStore defaultStore])
        {
            NSLog(@"DATA: Updating to iCloud");
            NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
            NSString *iCloudHighScoreString = [iCloudStore stringForKey: [self getiCloudHighScoreKey]];
            NSInteger iCloudHighScore = 0;
            if (iCloudHighScoreString != nil)
            {
                iCloudHighScore = [iCloudHighScoreString integerValue];
            }
            
            if (self.mHighScore > iCloudHighScore)
            {
                NSString *stringValue = [NSString stringWithFormat: @"%li", (long)self.mHighScore];
                [iCloudStore setString: stringValue forKey: [self getiCloudHighScoreKey]];
                [iCloudStore synchronize];
            }
        }
    }
}

- (void)updateFromiCloud
{
    if (Global_iCloudEnabled)
    {
        if ([NSUbiquitousKeyValueStore defaultStore])
        {
            NSLog(@"DATA: Updating from iCloud");
            NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
            NSString *iCloudHighScoreString = [iCloudStore stringForKey: [self getiCloudHighScoreKey]];
            NSInteger iCloudHighScore = 0;
            if (iCloudHighScoreString != nil)
            {
                iCloudHighScore = [iCloudHighScoreString integerValue];
            }
            
            if (iCloudHighScore > self.mHighScore)
            {
                self.mHighScore = iCloudHighScore;
            }
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
    NSLog(@"DATA: Deallocating instance of game data");
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end