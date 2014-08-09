//
//  DoubledIAPHelper.h
//  Doubled
//
//  Created by Matthew Remmel on 7/21/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "IAPHelper.h"

@interface DoubledIAPHelper : IAPHelper

+ (DoubledIAPHelper *)sharedInstance;

- (void)removeAds;

@end
