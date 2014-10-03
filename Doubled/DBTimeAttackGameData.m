//
//  DBTimeAttackGameData.m
//  Doubled
//
//  Created by Matthew on 8/11/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBTimeAttackGameData.h"
#import "DBGameGlobals.h"

#define DBGameDataTimeRemainingKey @"timeRemaining"

@implementation DBTimeAttackGameData

#pragma mark - Shared Instance

+ (DBTimeAttackGameData *)sharedInstance
{
    static DBTimeAttackGameData *sharedGameData;
    static dispatch_once_t once;
    dispatch_once(&once, ^
                  {
                      sharedGameData = [[self alloc] init];
                      NSLog(@"DATA: Created time attack shared game data instance");
                  });
    
    return sharedGameData;
}


#pragma mark - Initilization

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"DATA: Time attack game data initilized");
        if (![[NSFileManager defaultManager] fileExistsAtPath: [self getFilePath]])
        {
            [self saveGameData];
        }
        
        [self loadGameData];
    }
    
    return self;
}


#pragma mark - Overrides

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeDouble: self.mTimeRemaining forKey:DBGameDataTimeRemainingKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    self.mTimeRemaining = [decoder decodeDoubleForKey:DBGameDataTimeRemainingKey];
    return self;
}

- (NSData *)loadGameData
{
    NSData *decodedData = [super loadGameData];
    if (decodedData != nil)
    {
        DBTimeAttackGameData *data = (DBTimeAttackGameData *)[NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        self.mTimeRemaining = data. mTimeRemaining;
    }
    
    return decodedData;
}

- (NSString *)getFilePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0] stringByAppendingPathComponent:@"timeAttackGameData"];
    return filePath;
}

- (NSString *)getLeaderboardIdentifier
{
    return HighScoreTimeAttackIdentifier;
}

- (NSString *)getCheckSumIdentifier
{
    return TimeAttackGameDataChecksumKey;
}

- (NSString *)getiCloudHighScoreKey
{
    return HighScoreTimeAttackIdentifier;
}

@end
