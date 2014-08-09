//
//  DBRemoveAdsBanner.m
//  Doubled
//
//  Created by Matthew Remmel on 7/17/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBRemoveAdsBanner.h"
#import "DoubledIAPHelper.h"

@interface DBRemoveAdsBanner()

@end


@implementation DBRemoveAdsBanner

- (id)init
{
    self = [super initWithImage: [UIImage imageNamed: @"RemoveAdsBanner"]];
    return self;
}


#pragma mark - Touch Delegates

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[DoubledIAPHelper sharedInstance] removeAds];
}


@end
