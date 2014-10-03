//
//  DBTimeAttackGameData.h
//  Doubled
//
//  Created by Matthew on 8/11/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBGameData.h"

@interface DBTimeAttackGameData : DBGameData

+ (DBTimeAttackGameData *)sharedInstance;
@property double mTimeRemaining;

@end
