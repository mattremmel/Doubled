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

@property (weak, nonatomic) IBOutlet UIButton *buttonRemoveAds;
@property (weak, nonatomic) IBOutlet UIButton *buttonRestore;

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
    self.view.backgroundColor = defaultBackgroundColor;
    self.buttonRemoveAds.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonRestore.layer.cornerRadius = MenuButtonCornerRadius;
    
    [self.buttonRemoveAds setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonRestore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
