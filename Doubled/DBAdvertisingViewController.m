//
//  DBAdvertisingViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 8/6/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBAdvertisingViewController.h"
#import "DBGameGlobals.h"
#import "DoubledIAPHelper.h"

@interface DBAdvertisingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *mButtonRemoveAds;
@property (weak, nonatomic) IBOutlet UIButton *mButtonRestore;

@end

@implementation DBAdvertisingViewController

- (void)viewDidLoad
{
    NSLog(@"CONT: Advertising controller did load");
    [super viewDidLoad];
    [self styleView];
}

- (void)styleView
{
    self.view.backgroundColor = StandardBackgroundColor;
    self.mButtonRemoveAds.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonRestore.layer.cornerRadius = MenuButtonCornerRadius;
    
    [self.mButtonRemoveAds setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [self.mButtonRestore setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    
    self.mButtonRemoveAds.backgroundColor = StandardButtonColor;
    self.mButtonRestore.backgroundColor = StandardButtonColor;
}


#pragma mark - Button Events

- (IBAction)buttonRemoveAds:(id)sender
{
    [[DoubledIAPHelper sharedInstance] removeAds];
}

- (IBAction)buttonRestore:(id)sender
{
    [[DoubledIAPHelper sharedInstance] restoreCompletedTransactions];
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Advertising controller did deallocate");
}

@end
