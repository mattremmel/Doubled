//
//  MRGameViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 6/13/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "MRGameViewController.h"
#import "DBGameGlobals.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "DBRemoveAdsBanner.h"
#import <GameKit/GameKit.h>
#import <StoreKit/StoreKit.h>
#import "DoubledIAPHelper.h"
#import "MRTutorialViewController.h"


@interface MRGameViewController() <GADBannerViewDelegate, GKGameCenterControllerDelegate>

@property SKView *skView;
@property BOOL contentCreated;

@property GADBannerView *GADBannerView;
@property DBRemoveAdsBanner *removeAdsBanner;
@property BOOL GADBannerIsVisible;
@property BOOL removeAdsBannerIsVisible;
@property NSTimer *adTimer;

@end


#pragma mark - Implementation

@implementation MRGameViewController

# pragma mark - Configuration

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"CONT: MRGameViewController did load");
    
    // Purchased Observer
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(removeAdsPurchased) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissGameController) name:ReturnToMenu object:nil];

    // Configure the view
    [[UIApplication sharedApplication] setStatusBarHidden: true withAnimation:UIStatusBarAnimationFade];
    
    self.GADBannerIsVisible = false;
    [self configureGAD];
    [self configureRemoveAdsBanner];
    self.removeAdsBannerIsVisible = false;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureView];
    
    [self createContent];
    
    // Load ads and set timer
    [self loadAds];
    NSTimer *adTimer = [NSTimer scheduledTimerWithTimeInterval: 45.0 target: self selector:@selector(loadAds) userInfo: nil repeats: true];
    [adTimer setTolerance: 5];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.skView = nil;
    self.view = nil;
    self.adTimer = nil;
    self.contentCreated = false;
}

- (void)configureView
{
    NSLog(@"FUNC: Configuring controller view");
    
    self.skView = [[SKView alloc] initWithFrame:self.view.frame];
    self.view = self.skView;
    
    self.skView.showsFPS = true;
    self.skView.showsDrawCount = true;
    self.skView.showsNodeCount = true;
    self.skView.ignoresSiblingOrder = true;
    self.skView.multipleTouchEnabled = false;
    
    [self.GADBannerView bringSubviewToFront:self.view];
}

- (void)createContent
{
    if (!self.contentCreated)
    {
        //MRGameScene *gameScene = [[MRGameScene alloc] initWithSize:self.view.frame.size];
        
//        if (self.gameMode == GameModeNewNormalGame)
//        {
//            [gameScene setUpNewGame];
//            [self.skView presentScene:gameScene];
//        }
//        else if (self.gameMode == GameModeContinueNormalGame)
//        {
//            [gameScene setUpContinueGame];
//            [self.skView presentScene:gameScene];
//        }
//        else
//        {
//            NSLog(@"ERROR: Invalid game mode");
//            assert(false);
//        }
    }
    
    self.contentCreated = true;
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

#pragma mark - Game Center

- (void)showHighScoreNormalLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    //    gcViewController.leaderboardIdentifier = highScoreNormalIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Ad Requests

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
        NSLog(@"GAD:  Requesting google ad");
        GADRequest *request = [GADRequest request];
        request.testDevices = @[ @"6c58f45e4871b58e5f70e8be96d2b96e", @"Simulator" ];
        //TODO: [self.GADBannerView loadRequest: request];
        [self adView: nil didFailToReceiveAdWithError: nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"ERROR: Recieved memory warning");
}

- (void)dismissGameController
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)dealloc
{
    NSLog(@"Deallocating Game View Controller");
}

@end
