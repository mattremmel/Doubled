//
//  DBGameViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 8/1/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "DBGameScene.h"
#import "DBCasualGameScene.h"
#import "DBTimeAttackGameScene.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "DBRemoveAdsBanner.h"
#import "DoubledIAPHelper.h"
#import "DBGameGlobals.h"

@interface DBGameViewController () <GADBannerViewDelegate>

@property DBCasualGameScene *casualGameScene;
@property DBTimeAttackGameScene *timeAttackGameScene;
@property SKView *skView;
@property BOOL viewIsVisible;

@property GADBannerView *GADBannerView;
@property DBRemoveAdsBanner *removeAdsBanner;
@property BOOL GADBannerIsVisible;
@property BOOL removeAdsBannerIsVisible;
@property NSTimer *adTimer;

@end

@implementation DBGameViewController


#pragma mark - Initilization

- (id)init
{
    NSLog(@"CONT: Game controller initilized");
    self = [super init];
    if (self)
    {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self configureCasualGameScene];
    }
    
    return self;
}


#pragma mark - View Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Purchase Observer
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(removeAdsPurchased) name:IAPHelperProductPurchasedNotification object:nil];
    
    [self configureBannerView];
    
    self.adTimer = [NSTimer scheduledTimerWithTimeInterval: 45.0 target: self selector:@selector(loadAds) userInfo: nil repeats: true];
    [self.adTimer setTolerance: 5];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:self.GADBannerView];
    [self.view bringSubviewToFront:self.removeAdsBanner];
    
    self.viewIsVisible = true;
    [self loadAds];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.viewIsVisible = false;
}


#pragma mark - Configuration

- (void)configureBannerView
{
    self.GADBannerIsVisible = false;
    self.removeAdsBannerIsVisible = false;
    [self configureGAD];
    [self configureRemoveAdsBanner];
}

- (void)configureGAD
{
    if (!self.GADBannerView)
    {
        NSLog(@"GAD:  Configuring google ad banner");
        self.GADBannerView = [[GADBannerView alloc] init];
        [self.GADBannerView setAdUnitID: AdMobUnitID];
        [self.GADBannerView setRootViewController: self];
        [self.GADBannerView setDelegate: self];
        [self.GADBannerView setAdSize: kGADAdSizeSmartBannerPortrait];
        [self.GADBannerView setFrame: CGRectMake(0, self.view.frame.size.height, self.GADBannerView.frame.size.width, self.GADBannerView.frame.size.height)]; // Start off screen
        self.GADBannerIsVisible = false;
        [self.view addSubview: self.GADBannerView];
    }
}

- (void)configureRemoveAdsBanner
{
    NSLog(@"BAN:  Configuring remove ads banner");
    
    self.removeAdsBanner = [[DBRemoveAdsBanner alloc] init];
    [self.removeAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height, self.removeAdsBanner.frame.size.width, self.removeAdsBanner.frame.size.height)]; // Start off screen
    [self.removeAdsBanner setBackgroundColor: [UIColor blackColor]];
    [self.removeAdsBanner setUserInteractionEnabled: true];
    [self.view addSubview: self.removeAdsBanner];
}

- (void)configureCasualGameScene
{
    self.casualGameScene = [[DBCasualGameScene alloc] initWithSize:self.view.frame.size];
    self.casualGameScene.gameController = self;
}

- (void)configureTimeAttackGameScene
{
    self.timeAttackGameScene = [[DBTimeAttackGameScene alloc] init];
    self.timeAttackGameScene.gameController = self;
}


#pragma mark - Start Game

- (void)startCasualNewGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.casualGameScene setupNewGame];
    [self presentViewWithScene:self.casualGameScene];
}

- (void)startCasualContinueGame
{
    NSLog(@"CONT: Presenting continue casual game scene");
    [self.casualGameScene setupContinueGame];
    [self presentViewWithScene:self.casualGameScene];
}

- (void)startTimeAttackNewGame
{
    
}

- (void)startTimeAttackContinueGame
{
    
}

- (void)presentViewWithScene:(DBGameScene *)scene
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:self.skView];
    [self.skView presentScene:scene];
    [scene addInterface];
}


#pragma mark - Ad Request

- (void)loadAds
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey: RemoveAdsIdentifier])
    {
        // Remove Ads
        [self.GADBannerView removeFromSuperview];
        self.GADBannerView = nil;
        [self.removeAdsBanner removeFromSuperview];
        self.removeAdsBanner = nil;
    }
    else
    {
        if (self.viewIsVisible)
        {
            NSLog(@"GAD:  Requesting google ad");
            GADRequest *request = [GADRequest request];
            request.testDevices = @[ @"6c58f45e4871b58e5f70e8be96d2b96e", @"Simulator" ];
            [self.GADBannerView loadRequest: request];
        }
    }
}


#pragma mark - GAD Delegate Methods

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@"GAD:  Did recieve ad");
    
    // Move house ad off screen
    [UIView animateWithDuration: 0.5 animations:^{
        [self.removeAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height, self.removeAdsBanner.frame.size.width, self.removeAdsBanner.frame.size.height)];
    }completion:^(BOOL finished){
        self.removeAdsBannerIsVisible = false;
        
        // Show AdMob Ad
        if (!self.GADBannerIsVisible)
        {
            if (self.GADBannerView.superview == nil)
            {
                [self.view addSubview: self.GADBannerView];
            }
            
            [UIView animateWithDuration: 0.5 animations:^{
                [self.GADBannerView setFrame: CGRectMake(0, self.view.frame.size.height - self.GADBannerView.frame.size.height, self.GADBannerView.frame.size.width, self.GADBannerView.frame.size.height)];
            }];
            
            self.GADBannerIsVisible = true;
        }
    }];
}

- (void) adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"GAD:  Did fail to recieve ad");
    NSLog(@"Request Error: %@", error.description);
    
    [UIView animateWithDuration: 0.5 animations:^{
        [self.GADBannerView setFrame: CGRectMake(0, self.view.frame.size.height, self.GADBannerView.frame.size.width, self.GADBannerView.frame.size.height)];
    }completion:^(BOOL finished){
        self.GADBannerIsVisible = false;
    
        if (!self.removeAdsBannerIsVisible) {
            // Load house ad
            [UIView animateWithDuration: 0.5 animations:^{
                [self.removeAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height - self.removeAdsBanner.frame.size.height, self.removeAdsBanner.frame.size.width, self.removeAdsBanner.frame.size.height)];
            }completion:^(BOOL finished){
                self.removeAdsBannerIsVisible = true;
            }];
        }
    }];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    NSLog(@"GAD:  Will present screen");
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView
{
    NSLog(@"GAD:  Will dismiss screen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    NSLog(@"GAD:  Did dismiss screen");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    NSLog(@"GAD:  Will leave application");
}


#pragma mark - Remove Ads Purchase

- (void)removeAdsPurchased
{
    NSLog(@"Remove ads purchased");
    
    [self.GADBannerView removeFromSuperview];
    self.GADBannerView = nil;
    [self.removeAdsBanner removeFromSuperview];
    self.removeAdsBanner = nil;
}


#pragma mark - Controller Delegate Methods

- (void)dismissGameController
{
    [self.skView removeFromSuperview];
    self.skView = nil;
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return true;
}

- (BOOL)shouldAutorotate
{
    return false;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortraitUpsideDown;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Game controller did deallocate");
}

@end
