//
//  DBTile.m
//  Doubled
//
//  Created by Matthew Remmel on 6/14/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTile.h"
#import "DBGameGlobals.h"

#define MRGameDataTileValueKey @"tileValue"


@interface DBTile() <NSCoding, NSCopying>

@property NSInteger mValue;
@property SKLabelNode *mLabel;
@property BOOL mWasDeleted;

@end

#pragma mark - Implemenatation

@implementation DBTile

#pragma mark - Initialization

- (id)init
{
    return [self initWithValue: (long)((arc4random_uniform(2) + 1) * 2)];
}

- (id)initWithValue:(NSInteger)value
{
    CGSize size = CGSizeMake(Global_TileWidth - Global_TileSizeShrink, Global_TileHeight - Global_TileSizeShrink);
    self = [super initWithColor:[SKColor redColor] size:size];
    
    self.mValue = value;
    self.mWasDeleted = false;
    
    self.mLabel = [SKLabelNode labelNodeWithFontNamed: StandardFont];
    self.mLabel.text = [NSString stringWithFormat:@"%li", (long)self.mValue];
    self.mLabel.fontSize = Global_FontSize;
    self.mLabel.fontColor = StandardFontColor;
    self.mLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.mLabel.zPosition = 1;
    [self addChild: self.mLabel];
    
    [self updateTileWithValue: self.mValue];
    
    return self;
}


#pragma mark - NSCoding Protocol Methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger: self.mValue forKey: MRGameDataTileValueKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [[DBTile alloc] init];
    [self updateTileWithValue: [decoder decodeIntegerForKey: MRGameDataTileValueKey]];
    return self;
}


#pragma mark NSCopying Protocol Method

-(id)copyWithZone:(NSZone *)zone
{
    DBTile *copy = [[[self class] alloc] init];
    [copy updateTileWithValue: self.mValue];
    copy.position = self.position;
    return copy;
}


#pragma mark - Getters

- (NSInteger)getValue
{
    return self.mValue;
}

- (BOOL)isDeleted
{
    return self.mWasDeleted;
}

#pragma mark - Setters

- (void)markAsDeleted
{
    self.mWasDeleted = true;
}


#pragma mark - Tile Update

- (void)updateTileWithValue:(NSInteger)newValue
{
    assert(newValue != 0);
    
    self.mValue = newValue;
    self.mLabel.text = [NSString stringWithFormat:@"%li", (long)self.mValue];
    
    switch (self.mValue) {
        case 2:
            self.color = Tile2Color;
            self.mLabel.fontColor = StandardFontColor;
            break;
        case 4:
            self.color = Tile4Color;
            self.mLabel.fontColor = StandardFontColor;
            break;
        case 8:
            self.color = Tile8Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            break;
        case 16:
            self.color = Tile16Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            break;
        case 32:
            self.color = Tile32Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            break;
        case 64:
            self.color = Tile64Color;
            self.mLabel.fontColor = StandardFontColor;
            break;
        case 128:
            self.color = Tile128Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            break;
        case 256:
            self.color = Tile256Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            break;
        case 512:
            self.color = Tile512Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            break;
        case 1024:
            self.color = Tile1024Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            self.mLabel.fontSize = Global_FontSize - 5;
            break;
        case 2048:
            self.color = Tile2048Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            self.mLabel.fontSize = Global_FontSize - 5;
            break;
        case 4096:
            self.color = Tile4096Color;
            self.mLabel.fontColor = [SKColor whiteColor];
            self.mLabel.fontSize = Global_FontSize - 5;
            break;
        case 8192:
            self.color = TileDefaultColor;
            self.mLabel.fontColor = [SKColor whiteColor];
            self.mLabel.fontSize = Global_FontSize - 5;
            
            // Anything bigger than that needs a smaller font size
        default:
            self.color = TileDefaultColor;
            self.mLabel.fontColor = [SKColor whiteColor];
            self.mLabel.fontSize = Global_FontSize - 10;
            break;
    }
}

@end