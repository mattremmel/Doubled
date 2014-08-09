//
//  DBSettingsManager.m
//  Doubled
//
//  Created by Matthew Remmel on 7/31/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBSettingsManager.h"
#import "DBGameGlobals.h"

@implementation DBSettingsManager

+ (void)loadSettings
{
    NSLog(@"SETT: Loading settings");
    NSString *settingsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0] stringByAppendingPathComponent:@"settings"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:settingsFilePath])
    {
        NSDictionary *userSettings = [[NSDictionary alloc] initWithContentsOfFile:settingsFilePath];
        isFirstLaunch = [[userSettings valueForKey:isFirstLaunchKey] boolValue];
        continuousSwipeEnabled = [[userSettings valueForKey:continuousSwipeEnabledKey] boolValue];
        gameCenterEnabled = [[userSettings valueForKey:gameCenterEnabledKey] boolValue];
    }
    else
    {
        NSLog(@"SETT: Using default settings");
        NSMutableDictionary *defaultSettings = [[NSMutableDictionary alloc] init];
        [defaultSettings setValue:@YES forKey:isFirstLaunchKey];
        [defaultSettings setValue:@YES forKey:continuousSwipeEnabledKey];
        [defaultSettings setValue:@YES forKey:gameCenterEnabledKey];
        [defaultSettings writeToFile:settingsFilePath atomically:true];
        
        [self loadSettings];
    }
}

+ (void)saveSettings
{
    NSLog(@"SETT: Saving Settings");
    NSString *settingsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0] stringByAppendingPathComponent:@"settings"];
    NSMutableDictionary *userSettings = [[NSMutableDictionary alloc] init];
    [userSettings setObject:[NSNumber numberWithBool:isFirstLaunch] forKey:isFirstLaunchKey];
    [userSettings setObject:[NSNumber numberWithBool:continuousSwipeEnabled] forKey:continuousSwipeEnabledKey];
    [userSettings setObject:[NSNumber numberWithBool:gameCenterEnabled] forKey:gameCenterEnabledKey];
    [userSettings writeToFile:settingsFilePath atomically:true];
}

@end
