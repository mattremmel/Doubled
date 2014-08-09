//
//  DBTile.h
//  Doubled
//
//  Created by Matthew Remmel on 6/14/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DBTile : SKSpriteNode

- (id)init;
- (id)initWithValue:(NSInteger)value;
- (void)updateTileWithValue:(NSInteger)newValue;

- (NSInteger)getValue;
- (BOOL)isDeleted;

- (void)markAsDeleted;

@end