//
//  DoubledIAPHelper.m
//  Doubled
//
//  Created by Matthew Remmel on 7/21/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DoubledIAPHelper.h"
#import "DBGameGlobals.h"

@interface DoubledIAPHelper()

@property NSArray *products;

@end

@implementation DoubledIAPHelper

+ (DoubledIAPHelper *)sharedInstance
{
    static DoubledIAPHelper *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                  RemoveAdsIdentifier,
                                     nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers: productIdentifiers];
        [sharedInstance requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success)
            {
                sharedInstance.products = products;
            }
        }];
    });
    
    return sharedInstance;
}

- (void)removeAds
{
    if (self.products)
    {
        for (SKProduct *product in self.products)
        {
            if ([product.productIdentifier isEqualToString: RemoveAdsIdentifier])
            {
                [self buyProduct: product];
            }
        }
    }
}

@end
