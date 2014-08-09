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

@property NSInteger value;
@property SKLabelNode *label;
@property BOOL wasDeleted;

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
    CGSize size = CGSizeMake(tileWidth - 5, tileHeight - 5);
    self = [super initWithColor:[SKColor redColor] size:size];
    
    self.value = value;
    self.wasDeleted = false;
    
    self.label = [SKLabelNode labelNodeWithFontNamed: defaultFont];
    self.label.text = [NSString stringWithFormat:@"%li", (long)self.value];
    self.label.fontSize = 30;
    self.label.fontColor = defaultFontColor;
    self.label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.label.zPosition = 1;
    [self addChild: self.label];
    
    [self updateTileWithValue: self.value];
    
    return self;
}


#pragma mark - NSCoding Protocol Methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger: self.value forKey: MRGameDataTileValueKey];
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
    [copy updateTileWithValue: self.value];
    copy.position = self.position;
    return copy;
}


#pragma mark - Getters

- (NSInteger)getValue
{
    return self.value;
}

- (BOOL)isDeleted
{
    return self.wasDeleted;
}

#pragma mark - Setters

- (void)markAsDeleted
{
    self.wasDeleted = true;
}


#pragma mark - Tile Update

- (void)updateTileWithValue:(NSInteger)newValue
{
    assert(newValue != 0);
    
    self.value = newValue;
    self.label.text = [NSString stringWithFormat:@"%li", (long)self.value];
    
    switch (self.value) {
        case 2:
            self.color = tile2Color;
            self.label.fontColor = defaultFontColor;
            break;
        case 4:
            self.color = tile4Color;
            self.label.fontColor = defaultFontColor;
            break;
        case 8:
            self.color = tile8Color;
            self.label.fontColor = [SKColor whiteColor];
            break;
        case 16:
            self.color = tile16Color;
            self.label.fontColor = [SKColor whiteColor];
            break;
        case 32:
            self.color = tile32Color;
            self.label.fontColor = [SKColor whiteColor];
            break;
        case 64:
            self.color = tile64Color;
            self.label.fontColor = defaultFontColor;
            break;
        case 128:
            self.color = tile128Color;
            self.label.fontColor = [SKColor whiteColor];
            break;
        case 256:
            self.color = tile256Color;
            self.label.fontColor = [SKColor whiteColor];
            break;
        case 512:
            self.color = tile512Color;
            self.label.fontColor = [SKColor whiteColor];
            break;
        case 1024:
            self.color = tile1024Color;
            self.label.fontColor = [SKColor whiteColor];
            self.label.fontSize = 25;
            break;
        case 2048:
            self.color = tile2048Color;
            self.label.fontColor = [SKColor whiteColor];
            self.label.fontSize = 25;
            break;
        case 4096:
            self.color = tile4096Color;
            self.label.fontColor = [SKColor whiteColor];
            self.label.fontSize = 25;
            break;
        case 8192:
            self.color = tileDefaultColor;
            self.label.fontColor = [SKColor whiteColor];
            self.label.fontSize = 25;
            
            // Anything bigger than that needs a smaller font size
        default:
            self.color = tileDefaultColor;
            self.label.fontColor = [SKColor whiteColor];
            self.label.fontSize = 20;
            break;
    }
}

@end