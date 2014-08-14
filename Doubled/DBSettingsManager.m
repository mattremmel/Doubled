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
        ContinuousSwipeEnabled = [[userSettings valueForKey:ContinuousSwipeEnabledKey] boolValue];
        GameCenterEnabled = [[userSettings valueForKey:GameCenterEnabledKey] boolValue];
        iCloudEnabled = [[userSettings valueForKey:iCloudEnabledKey] boolValue];
        TouchTolerance = [[userSettings valueForKey:TouchToleranceKey] integerValue];
        if (TouchTolerance == 0)
        {
            if (deviceType == iPadType)
            {
                TouchTolerance = 60;
            }
            else
            {
                TouchTolerance = 40;
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
    [userSettings setObject:[NSNumber numberWithBool:ContinuousSwipeEnabled] forKey:ContinuousSwipeEnabledKey];
    [userSettings setObject:[NSNumber numberWithBool:GameCenterEnabled] forKey:GameCenterEnabledKey];
    [userSettings setObject:[NSNumber numberWithBool:iCloudEnabled] forKey:iCloudEnabledKey];
    [userSettings writeToFile:settingsFilePath atomically:true];
}

+ (void)resetSettings
{
    NSLog(@"SETT: Using default settings");
    NSMutableDictionary *defaultSettings = [[NSMutableDictionary alloc] init];
     NSString *settingsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0] stringByAppendingPathComponent:@"settings"];
    [defaultSettings setValue:@YES forKey:ContinuousSwipeEnabledKey];
    [defaultSettings setValue:@YES forKey:GameCenterEnabledKey];
    [defaultSettings setValue:@YES forKey:iCloudEnabledKey];
    
    if (deviceType == iPadType)
    {
        [defaultSettings setValue:@60 forKey:TouchToleranceKey];
    }
    else
    {
        [defaultSettings setValue:@40 forKey:TouchToleranceKey];
    }
    
    
    
    [defaultSettings writeToFile:settingsFilePath atomically:true];
    
    [self loadSettings];
}

@end
