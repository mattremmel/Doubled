//
//  DBTimeAttackGameData.m
//  Doubled
//
//  Created by Matthew on 8/11/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBTimeAttackGameData.h"
#import "DBGameGlobals.h"

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

- (NSString *)getFilePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0] stringByAppendingPathComponent:@"timeAttackGameData"];
    return filePath;
}

- (NSString *)getLeaderboardIdentifier
{
    return highScoreTimeAttackIdentifier;
}

- (NSString *)getiCloudHighScoreKey
{
    return highScoreTimeAttackIdentifier;
}

@end
