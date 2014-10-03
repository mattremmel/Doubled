//
//  DBCasualGameScene.m
//  Doubled
//
//  Created by Matthew Remmel on 8/1/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBCasualGameScene.h"
#import "DBGameInterface.h"
#import "DBCasualGameData.h"

@interface DBCasualGameScene()

@property BOOL mContentCreated;

@end

@implementation DBCasualGameScene


#pragma mark - Initilization

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self createContent];
        self.mGameData = [DBCasualGameData sharedInstance];
    }
    
    NSLog(@"SCNE: Casual game scene initilized");
    return self;
}


#pragma mark - Setup

- (void)createContent
{
    if (!self.mContentCreated)
    {
        // TODO: Additional casual game only setup
        
        self.mContentCreated = true;
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"SCNE: Casual game scene did deallocate");
}


@end
