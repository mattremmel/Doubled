//
//  DBDonationViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 8/6/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBDonationViewController.h"
#import "DBGameGlobals.h"

@interface DBDonationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *mButtonDonate;

@end

@implementation DBDonationViewController

- (void)viewDidLoad
{
    NSLog(@"CONT: Advertising controller did load");
    [super viewDidLoad];
    [self styleView];
}

- (void)styleView
{
    self.view.backgroundColor = StandardBackgroundColor;
    self.mButtonDonate.layer.cornerRadius = MenuButtonCornerRadius;
    
    [self.mButtonDonate setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    
    self.mButtonDonate.backgroundColor = StandardButtonColor;
    
    [self.mButtonDonate addTarget:self action:@selector(buttonRemoveAdsNormalColor) forControlEvents:UIControlEventTouchUpInside];
    [self.mButtonDonate addTarget:self action:@selector(buttonRemoveAdsNormalColor) forControlEvents:UIControlEventTouchUpOutside];
    [self.mButtonDonate addTarget:self action:@selector(buttonRemoveAdsHighlightColor) forControlEvents:UIControlEventTouchDown];
}


#pragma mark - 

- (IBAction)buttonDonate:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DonationURL]];
}


#pragma mark - Button Highlights

- (void)buttonRemoveAdsNormalColor {
    self.mButtonDonate.backgroundColor = StandardButtonColor;
}

- (void)buttonRemoveAdsHighlightColor {
    self.mButtonDonate.backgroundColor = StandardButtonPressedColor;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Advertising controller did deallocate");
}

@end
