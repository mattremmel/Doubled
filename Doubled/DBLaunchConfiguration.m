//
//  DBLaunchConfiguration.m
//  Doubled
//
//  Created by Matthew Remmel on 7/30/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBLaunchConfiguration.h"
#import "DBGameGlobals.h"
#import "DBSettingsManager.h"

@implementation DBLaunchConfiguration

+ (void)configureLaunchSettingsWithScreenSize:(CGSize)size
{
    [self setDeviceDataWithSize:size];
    [DBSettingsManager loadSettings];
}

+ (void)setDeviceDataWithSize:(CGSize)size
{
    if (size.width == 320 && size.height == 480) // iPhone 4, iPhone 3, iPhone 2, iPod Touch
    {
        deviceType = iPhone4Type;
        tileWidth = 75;
        tileHeight = 75;
        columnCount = 4;
        rowCount = 4;
        touchTolerance = 35;
    }
    else if (size.width == 320 && size.height == 568) // iPhone 5
    {
        deviceType = iPhone5Type;
        tileWidth = 75;
        tileHeight = 75;
        columnCount = 4;
        rowCount = 4;
        touchTolerance = 35;
    }
    else if (size.width == 768 && size.height == 1024) // iPad
    {
        deviceType = iPadType;
        tileWidth = 150;
        tileHeight = 150;
        columnCount = 4;
        rowCount = 4;
        touchTolerance = 35;
    }
    else
    {
        deviceType = unknownType;
        tileWidth = 75;
        tileHeight = 75;
        columnCount = 4;
        rowCount = 4;
        touchTolerance = 35;
    }
}



@end