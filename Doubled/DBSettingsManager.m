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
        touchTolerance = [[userSettings valueForKey:touchToleranceKey] integerValue];
        if (touchTolerance == 0)
        {
            if (deviceType == iPadType)
            {
                touchTolerance = 60;
            }
            else
            {
                touchTolerance = 40;
            }
        }
    }
    else
    {
        [self resetSettings];
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

+ (void)resetSettings
{
    NSLog(@"SETT: Using default settings");
    NSMutableDictionary *defaultSettings = [[NSMutableDictionary alloc] init];
     NSString *settingsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0] stringByAppendingPathComponent:@"settings"];
    [defaultSettings setValue:@YES forKey:isFirstLaunchKey];
    [defaultSettings setValue:@YES forKey:continuousSwipeEnabledKey];
    [defaultSettings setValue:@YES forKey:gameCenterEnabledKey];
    
    if (deviceType == iPadType)
    {
        [defaultSettings setValue:@60 forKey:touchToleranceKey];
    }
    else
    {
        [defaultSettings setValue:@40 forKey:touchToleranceKey];
    }
    
    
    
    [defaultSettings writeToFile:settingsFilePath atomically:true];
    
    [self loadSettings];
}

@end
