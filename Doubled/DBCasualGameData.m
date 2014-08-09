//
//  DBCasualGameData.m
//  Doubled
//
//  Created by Matthew Remmel on 8/3/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBCasualGameData.h"
#import "DBGameGlobals.h"

@implementation DBCasualGameData


#pragma mark - Shared Instance
+ (DBCasualGameData *)sharedInstance
{
    static DBCasualGameData *sharedGameData;
    static dispatch_once_t once;
    dispatch_once(&once, ^
          {
              sharedGameData = [[self alloc] init];
              NSLog(@"DATA: Created casual shared game data instance");
          });
    
    return sharedGameData;
}


#pragma mark - Initilization

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"DATA: Casual game data initilized");
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
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0] stringByAppendingPathComponent:@"casualGameData"];
    return filePath;
}

- (NSString *)getLeaderboardIdentifier
{
    return highScoreCasualIdentifier;
}

- (NSString *)getiCloudHighScoreKey
{
    return highScoreCasualIdentifier;
}

@end
