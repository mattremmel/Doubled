//
//  DBSettingsManager.h
//  Doubled
//
//  Created by Matthew Remmel on 7/31/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBSettingsManager : NSObject

+ (void)loadSettings;
+ (void)saveSettings;

@end
