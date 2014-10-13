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
        Global_DeviceType = iPhone4Type;
        Global_TileWidth = 75;
        Global_TileHeight = 75;
        Global_FontSize = 25;
        Global_TileSizeShrink = 5;
        Global_ColumnCount = 4;
        Global_RowCount = 4;
    }
    else if (size.width == 320 && size.height == 568) // iPhone 5
    {
        Global_DeviceType = iPhone5Type;
        Global_TileWidth = 75;
        Global_TileHeight = 75;
        Global_FontSize = 25;
        Global_TileSizeShrink = 5;
        Global_ColumnCount = 4;
        Global_RowCount = 4;
    }
    else if (size.width == 768 && size.height == 1024) // iPad
    {
        Global_DeviceType = iPadType;
        Global_TileWidth = 140;
        Global_TileHeight = 140;
        Global_FontSize = 40;
        Global_TileSizeShrink = 6;
        Global_ColumnCount = 4;
        Global_RowCount = 4;
    }
    else
    {
        Global_DeviceType = UnknownType;
        Global_TileWidth = 75;
        Global_TileHeight = 75;
        Global_FontSize = 25;
        Global_TileSizeShrink = 5;
        Global_ColumnCount = 4;
        Global_RowCount = 4;
    }
}



@end
